import SwiftUI
import FirebaseAuth

enum AppTab: Hashable {
    case discover, likes, matches, profile
}

struct MainTabView: View {
    @Environment(AuthManager.self) private var auth
    @Environment(DogManager.self) private var dogs
    @Environment(SwipeManager.self) private var swipes
    @Environment(MatchManager.self) private var matchManager

    @State private var selection: AppTab = .discover

    private var myUid: String { auth.user?.uid ?? "" }

    var body: some View {
        TabView(selection: $selection) {
            DiscoverView()
                .tabItem { Label("Discover", systemImage: "pawprint.fill") }
                .tag(AppTab.discover)
            LikesView()
                .tabItem { Label("Likes", systemImage: "heart.fill") }
                .badge(matchManager.likes.count)                // hidden when zero
                .tag(AppTab.likes)
            MatchesView()
                .tabItem { Label("Matches", systemImage: "bubble.left.and.bubble.right.fill") }
                .badge(matchManager.unreadCount(for: myUid))    // unread chats and new matches
                .tag(AppTab.matches)
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
                .tag(AppTab.profile)
        }
        // starts the live listeners as soon as the dog is known, so both badges fill in at launch
        .task(id: dogs.myDog?.id) {
            guard let uid = auth.user?.uid, let dogId = dogs.myDog?.id else { return }
            matchManager.start(myOwnerId: uid, myDogId: dogId)
        }
        .onDisappear { matchManager.stop() }                    // sign out clears everything
        .fullScreenCover(item: Binding(get: { swipes.newMatch }, set: { swipes.newMatch = $0 })) { dog in
            MatchPopupView(myDog: dogs.myDog, otherDog: dog,
                           onMessage: { swipes.newMatch = nil; selection = .matches },
                           onClose: { swipes.newMatch = nil })
        }
    }
}

// temporary screen for tabs we haven't built yet (no longer used, safe to keep)
struct PlaceholderView: View {
    let title: String
    let symbol: String
    let message: String

    var body: some View {
        NavigationStack {
            ContentUnavailableView(title, systemImage: symbol, description: Text(message))
                .navigationTitle(title)
        }
    }
}
