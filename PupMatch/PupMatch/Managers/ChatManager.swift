import Foundation
import Observation
import FirebaseFirestore

@Observable
final class ChatManager {
    var messages: [Message] = []
    var errorMessage: String?

    @ObservationIgnored private let db = Firestore.firestore()
    @ObservationIgnored private var listener: ListenerRegistration?

    // real-time: every new message on either phone arrives here, oldest first
    func listen(matchId: String) {
        listener?.remove()
        listener = db.collection("matches").document(matchId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] snap, _ in
                guard let self, let snap else { return }
                self.messages = snap.documents.compactMap { try? $0.data(as: Message.self) }
            }
    }

    func send(_ text: String, matchId: String, senderId: String, recipientId: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let matchRef = db.collection("matches").document(matchId)
        do {
            let message = Message(id: nil, senderId: senderId, text: trimmed, timestamp: nil)
            try matchRef.collection("messages").addDocument(from: message)
            // preview and sort time for the list, plus flag the chat as unread for the other owner
            try await matchRef.updateData([
                "lastMessage": trimmed,
                "lastMessageTime": FieldValue.serverTimestamp(),
                "unreadBy": FieldValue.arrayUnion([recipientId])
            ])
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // removes this owner from the unread list; safe to call when nothing is unread
    func markRead(matchId: String, myUid: String) async {
        try? await db.collection("matches").document(matchId)
            .updateData(["unreadBy": FieldValue.arrayRemove([myUid])])
    }

    func stop() {
        listener?.remove()
        listener = nil
        messages = []
    }
}
