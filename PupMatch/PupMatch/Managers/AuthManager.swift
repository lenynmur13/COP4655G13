import Foundation
import Observation
import FirebaseAuth
import FirebaseFirestore

@Observable
final class AuthManager {
    var user: User?                      // Firebase Auth user; nil means logged out
    var owner: Owner?                    // matching Firestore profile
    var errorMessage: String?
    var isLoading = false

    @ObservationIgnored private var handle: AuthStateDidChangeListenerHandle?
    @ObservationIgnored private let db = Firestore.firestore()

    init() {
        user = Auth.auth().currentUser   // restore session instantly so we don't flash the login screen
        if let user { Task { await loadOwner(uid: user.uid) } }

        // fires on login, logout, and app relaunch
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            self.user = user
            if let user { Task { await self.loadOwner(uid: user.uid) } } else { self.owner = nil }
        }
    }

    deinit {
        if let handle { Auth.auth().removeStateDidChangeListener(handle) }
    }

    func signUp(email: String, password: String, displayName: String, city: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }      // always runs, success or failure
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let newOwner = Owner(id: nil, email: email, displayName: displayName, city: city, createdAt: nil)
            // doc ID = uid so any collection can find the owner without a query
            try db.collection("users").document(result.user.uid).setData(from: newOwner)
            await loadOwner(uid: result.user.uid) // listener may have fired before the doc existed, so load again
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadOwner(uid: String) async {
        do {
            let snap = try await db.collection("users").document(uid).getDocument()
            owner = try snap.data(as: Owner.self)
        } catch {
            owner = nil                  // doc missing or undecodable; the UI handles a nil owner
        }
    }
}
