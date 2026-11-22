import Foundation
import Observation
import FirebaseFirestore

// a match plus the other owner's dog, ready for the list
struct MatchItem: Identifiable {
    let match: Match
    let otherDog: Dog
    var id: String { match.id ?? "" }

    func isUnread(for uid: String) -> Bool {
        match.unreadBy?.contains(uid) ?? false
    }
}

@Observable
final class MatchManager {
    var matches: [MatchItem] = []        // live, newest activity first
    var likes: [Dog] = []                // dogs that liked mine and I haven't answered yet
    var errorMessage: String?

    @ObservationIgnored private let db = Firestore.firestore()
    @ObservationIgnored private var matchListener: ListenerRegistration?
    @ObservationIgnored private var likesListener: ListenerRegistration?
    @ObservationIgnored private var dogCache: [String: Dog] = [:]   // avoids re-fetching the same dog

    // conversations (including brand-new matches) this owner hasn't opened yet; drives the tab badge
    func unreadCount(for uid: String) -> Int {
        matches.filter { $0.isUnread(for: uid) }.count
    }

    // starts both live listeners; the badges fill in right after launch
    func start(myOwnerId: String, myDogId: String) {
        removeListeners()

        // matches: fires when a match is created or its last message and unread list change
        matchListener = db.collection("matches")
            .whereField("participants", arrayContains: myOwnerId)
            .addSnapshotListener { [weak self] snap, _ in
                guard let self, let snap else { return }
                let found = snap.documents.compactMap { try? $0.data(as: Match.self) }
                Task { await self.resolve(found, myDogId: myDogId) }
            }

        // likes: any new swipe aimed at my dog re-runs the lookup, so the Likes badge is live
        likesListener = db.collection("swipes")
            .whereField("toDog", isEqualTo: myDogId)
            .addSnapshotListener { [weak self] _, _ in
                guard let self else { return }
                Task { await self.loadLikes(myDogId: myDogId) }
            }
    }

    // attach the other dog to each match, then sort (client side, so no Firestore index is needed)
    private func resolve(_ found: [Match], myDogId: String) async {
        var items: [MatchItem] = []
        for match in found {
            guard let otherId = match.dogs.first(where: { $0 != myDogId }),
                  let other = await fetchDog(id: otherId) else { continue }
            items.append(MatchItem(match: match, otherDog: other))
        }
        items.sort { ($0.match.lastMessageTime ?? Date()) > ($1.match.lastMessageTime ?? Date()) }
        matches = items
    }

    // swipes where someone liked my dog, minus the ones I've already answered
    func loadLikes(myDogId: String) async {
        do {
            let likedMe = try await db.collection("swipes")
                .whereField("toDog", isEqualTo: myDogId)
                .whereField("direction", isEqualTo: SwipeDirection.like.rawValue)
                .getDocuments()
            let mine = try await db.collection("swipes")
                .whereField("fromDog", isEqualTo: myDogId)
                .getDocuments()
            let answered = Set(mine.documents.compactMap { $0.data()["toDog"] as? String })

            var result: [Dog] = []
            for doc in likedMe.documents {
                guard let fromId = doc.data()["fromDog"] as? String,
                      !answered.contains(fromId),
                      let dog = await fetchDog(id: fromId) else { continue }
                result.append(dog)
            }
            likes = result
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func removeLike(_ dog: Dog) {
        likes.removeAll { $0.id == dog.id }
    }

    // called on sign out so the next account starts clean
    func stop() {
        removeListeners()
        matches = []
        likes = []
        dogCache = [:]
    }

    private func removeListeners() {
        matchListener?.remove()
        likesListener?.remove()
        matchListener = nil
        likesListener = nil
    }

    private func fetchDog(id: String) async -> Dog? {
        if let cached = dogCache[id] { return cached }
        guard let snap = try? await db.collection("dogs").document(id).getDocument(),
              let dog = try? snap.data(as: Dog.self) else { return nil }
        dogCache[id] = dog
        return dog
    }
}
