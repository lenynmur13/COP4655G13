import SwiftUI

struct ContentView: View {
    @Environment(AuthManager.self) private var auth

    var body: some View {
        // logged out shows login/signup; logged in shows the app
        if auth.user == nil {
            AuthView()
        } else {
            HomeView()
        }
    }
}
