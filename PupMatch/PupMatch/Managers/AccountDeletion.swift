//
//  AccountDeletion.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/22/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension AuthManager {
    func deleteAccount(password: String) async -> Bool {
        guard let user = Auth.auth().currentUser, let email = user.email else { return false }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let db = Firestore.firestore()
        let uid = user.uid
        do {
            // 1. prove it's really them
            try await user.reauthenticate(with: EmailAuthProvider.credential(withEmail: email, password: password))

            // 2. matches, including every chat message
            let matches = try await db.collection("matches").whereField("participants", arrayContains: uid).getDocuments()
            for match in matches.documents { try await MatchCleanup.delete(match.reference) }

            // 3. swipes this owner made and swipes aimed at this owner
            for field in ["fromOwner", "toOwner"] {
                let swipes = try await db.collection("swipes").whereField(field, isEqualTo: uid).getDocuments()
                for swipe in swipes.documents { try await swipe.reference.delete() }
            }

            // 4. the dog and the owner profile
            let dogs = try await db.collection("dogs").whereField("ownerId", isEqualTo: uid).getDocuments()
            for dog in dogs.documents { try await dog.reference.delete() }
            try await db.collection("users").document(uid).delete()

            // 5. the login itself; this also signs out, which sends the app back to the login screen
            try await user.delete()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
