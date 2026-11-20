import SwiftUI
import FirebaseCore

@main
struct PupMatchApp: App {
    @State private var auth: AuthManager

    init() {
        FirebaseApp.configure()          // must run before anything calls Auth or Firestore
        _auth = State(initialValue: AuthManager())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(auth)       // every view reads the same AuthManager
        }
    }
}
