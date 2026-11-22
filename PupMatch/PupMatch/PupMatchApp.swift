import SwiftUI
import FirebaseCore

@main
struct PupMatchApp: App {
    @State private var auth: AuthManager
    @State private var dogs: DogManager
    @State private var swipes: SwipeManager
    @State private var matchManager: MatchManager
    @State private var locationManager = LocationManager()   // doesn't touch Firebase, so no ordering issue

    init() {
        FirebaseApp.configure()          // must run before anything calls Auth or Firestore
        _auth = State(initialValue: AuthManager())
        _dogs = State(initialValue: DogManager())
        _swipes = State(initialValue: SwipeManager())
        _matchManager = State(initialValue: MatchManager())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(auth)       // every view reads the same managers
                .environment(dogs)
                .environment(swipes)
                .environment(matchManager)
                .environment(locationManager)
        }
    }
}
