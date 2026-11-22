//
//  DogManager.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/22/26.
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
final class DogManager {
    var myDog: Dog?                      // the logged-in owner's dog; nil means onboarding is needed
    var isLoaded = false                 // false until the first lookup finishes, prevents a form flash
    var isSaving = false
    var errorMessage: String?

    @ObservationIgnored private let db = Firestore.firestore()

    // find the dog whose ownerId matches this uid (one dog per owner for now)
    func loadMyDog(ownerId: String) async {
        do {
            let snap = try await db.collection("dogs")
                .whereField("ownerId", isEqualTo: ownerId)
                .limit(to: 1)
                .getDocuments()
            myDog = try snap.documents.first?.data(as: Dog.self)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoaded = true
    }

    // create a new dog, or overwrite the existing one when it already has an id
    func saveDog(_ dog: Dog) async -> Bool {
        isSaving = true
        errorMessage = nil
        defer { isSaving = false }
        do {
            if let id = dog.id {
                try db.collection("dogs").document(id).setData(from: dog)
                myDog = dog
            } else {
                let ref = try db.collection("dogs").addDocument(from: dog)
                let saved = try await ref.getDocument()      // read back so myDog has its new id
                myDog = try saved.data(as: Dog.self)
            }
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    // called on sign out so the next login starts clean
    func reset() {
        myDog = nil
        isLoaded = false
        errorMessage = nil
    }
}
