//
//  MatchCleanup.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/22/26.
//

import Foundation
import FirebaseFirestore

enum MatchCleanup {
    // deletes every message first (the rules check the match document), then the match itself
    static func delete(_ matchRef: DocumentReference) async throws {
        let db = Firestore.firestore()
        let messages = try await matchRef.collection("messages").getDocuments().documents

        // a batch holds at most 500 writes, so go in chunks of 400
        for start in stride(from: 0, to: messages.count, by: 400) {
            let batch = db.batch()
            for doc in messages[start..<min(start + 400, messages.count)] {
                batch.deleteDocument(doc.reference)
            }
            try await batch.commit()
        }
        try await matchRef.delete()
    }
}

extension MatchManager {
    // the live listener drops the match from the list once it's gone
    func unmatch(_ item: MatchItem) async -> Bool {
        guard let id = item.match.id else { return false }
        do {
            try await MatchCleanup.delete(Firestore.firestore().collection("matches").document(id))
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
