//
//  SwipeManager.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/22/26.
//

import Foundation
import Observation
import CoreLocation
import FirebaseFirestore

@Observable
final class SwipeManager {
    var deck: [Dog] = []                 // candidates; the first one is the card on top
    var isLoading = false
    var newMatch: Dog?                   // the other dog from a just-created match; drives the popup
    var errorMessage: String?

    @ObservationIgnored private let db = Firestore.firestore()

    // build the deck: opposite sex, not mine, not already swiped, nearest first
    func loadDeck(for myDog: Dog, userLocation: CLLocation?) async {
        guard let myId = myDog.id else { return }
        isLoading = true
        deck = []                        // clears a previous user's deck while loading
        defer { isLoading = false }
        do {
            // every dog this one has already liked or passed
            let swipeSnap = try await db.collection("swipes")
                .whereField("fromDog", isEqualTo: myId)
                .getDocuments()
            let seen = Set(swipeSnap.documents.compactMap { $0.data()["toDog"] as? String })

            let wanted: DogSex = (myDog.sex == .male) ? .female : .male
            let dogSnap = try await db.collection("dogs")
                .whereField("sex", isEqualTo: wanted.rawValue)
                .limit(to: 100)
                .getDocuments()

            var candidates = dogSnap.documents
                .compactMap { try? $0.data(as: Dog.self) }
                .filter { $0.ownerId != myDog.ownerId && !seen.contains($0.id ?? "") }

            // distance in meters; dogs with no saved location sort to the end
            func meters(_ dog: Dog) -> Double {
                guard let user = userLocation, let lat = dog.latitude, let lon = dog.longitude else {
                    return .greatestFiniteMagnitude
                }
                return user.distance(from: CLLocation(latitude: lat, longitude: lon))
            }
            candidates.sort { meters($0) < meters($1) }
            deck = candidates
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // remove the card right away so the UI never flashes it again, then save in the background
    func swipe(_ direction: SwipeDirection, on dog: Dog, with myDog: Dog) {
        deck.removeAll { $0.id == dog.id }
        Task { await record(direction, on: dog, with: myDog) }
    }

    private func record(_ direction: SwipeDirection, on dog: Dog, with myDog: Dog) async {
        guard let myId = myDog.id, let theirId = dog.id else { return }
        do {
            let swipe = Swipe(id: nil, fromDog: myId, toDog: theirId,
                              fromOwner: myDog.ownerId, toOwner: dog.ownerId,
                              direction: direction, createdAt: nil)
            // fixed document ID means swiping the same dog twice just overwrites
            try db.collection("swipes").document("\(myId)_\(theirId)").setData(from: swipe)

            guard direction == .like else { return }

            // did their owner already like my dog?
            let reverse = try await db.collection("swipes").document("\(theirId)_\(myId)").getDocument()
            guard reverse.exists,
                  reverse.data()?["direction"] as? String == SwipeDirection.like.rawValue else { return }

            // mutual like: one match per pair, ID = sorted dog IDs
            let matchRef = db.collection("matches").document([myId, theirId].sorted().joined(separator: "_"))
            let existing = try await matchRef.getDocument()
            if !existing.exists {        // don't wipe an existing chat if both swiped at once
                let match = Match(id: nil, participants: [myDog.ownerId, dog.ownerId],
                                  dogs: [myId, theirId], lastMessage: "", lastMessageTime: Date(),
                                  unreadBy: [myDog.ownerId, dog.ownerId])   // both owners see a new match until they open the chat
                try matchRef.setData(from: match)
            }
            newMatch = dog               // triggers the "It's a match!" screen
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
