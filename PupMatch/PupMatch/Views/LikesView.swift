//
//  LikesView.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/22/26.
//

import SwiftUI

struct LikesView: View {
    @Environment(DogManager.self) private var dogs
    @Environment(SwipeManager.self) private var swipes
    @Environment(MatchManager.self) private var matchManager
    @Environment(LocationManager.self) private var locationManager

    var body: some View {
        NavigationStack {
            Group {
                if matchManager.likes.isEmpty {
                    ContentUnavailableView("No likes yet",
                                           systemImage: "heart",
                                           description: Text("Dogs whose owners liked yours will show up here."))
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(matchManager.likes) { dog in row(dog) }
                        }
                        .padding(20)
                    }
                }
            }
            .background(Theme.background)
            .navigationTitle("Likes")
            .refreshable { await reload() }                     // pull down to refresh
        }
        .onAppear { Task { await reload() } }                   // refresh every time the tab opens
    }

    private func row(_ dog: Dog) -> some View {
        HStack(spacing: 14) {
            DogAvatar(dog: dog, size: 72)
            VStack(alignment: .leading, spacing: 4) {
                Text(dog.name).font(.headline)
                Text("\(dog.breed) · \(dog.ageYears)").font(.subheadline).foregroundStyle(.secondary)
                if let proximity = Proximity.between(locationManager.location, and: dog) {
                    Label(proximity.rawValue, systemImage: "location.fill")
                        .font(.caption).foregroundStyle(Theme.accent)
                }
            }
            Spacer()
            HStack(spacing: 10) {
                smallCircle(symbol: "xmark", color: Theme.pass) { respond(.pass, to: dog) }
                smallCircle(symbol: "heart.fill", color: Theme.like) { respond(.like, to: dog) }
            }
        }
        .card()
    }

    private func smallCircle(symbol: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.headline.weight(.bold))
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.12), in: Circle())   // tonal circle, Material style
        }
    }

    // liking back always matches (they already liked mine); the popup is shown by MainTabView
    private func respond(_ direction: SwipeDirection, to dog: Dog) {
        guard let myDog = dogs.myDog else { return }
        withAnimation { matchManager.removeLike(dog) }
        swipes.swipe(direction, on: dog, with: myDog)
    }

    private func reload() async {
        guard let dogId = dogs.myDog?.id else { return }
        await matchManager.loadLikes(myDogId: dogId)
    }
}
