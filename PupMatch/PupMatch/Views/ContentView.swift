import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @Environment(AuthManager.self) private var auth
    @Environment(DogManager.self) private var dogs

    var body: some View {
        Group {
            if auth.user == nil {
                AuthView()                              // logged out
            } else if !dogs.isLoaded {
                ProgressView().controlSize(.large)      // checking whether this owner already has a dog
            } else if dogs.myDog == nil {
                DogFormView(existing: nil)              // first login: create the dog profile
            } else {
                MainTabView()                           // the real app
            }
        }
        .tint(Theme.accent)
        // runs on launch and again whenever the logged-in user changes
        .task(id: auth.user?.uid) {
            if let uid = auth.user?.uid {
                await dogs.loadMyDog(ownerId: uid)
            } else {
                dogs.reset()
            }
        }
    }
}
