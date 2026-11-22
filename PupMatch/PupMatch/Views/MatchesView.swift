import SwiftUI
import FirebaseAuth

struct MatchesView: View {
    @Environment(AuthManager.self) private var auth
    @Environment(MatchManager.self) private var matchManager

    @State private var pending: MatchItem?                       // the match waiting for unmatch confirmation

    private var myUid: String { auth.user?.uid ?? "" }

    var body: some View {
        NavigationStack {
            Group {
                if matchManager.matches.isEmpty {
                    ContentUnavailableView("No matches yet",
                                           systemImage: "bubble.left.and.bubble.right",
                                           description: Text("When you and another owner like each other's dogs, you can chat here."))
                } else {
                    List(matchManager.matches) { item in
                        NavigationLink {
                            ChatView(item: item)
                        } label: {
                            row(item)
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Unmatch", role: .destructive) { pending = item }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Matches")
            .confirmationDialog("Unmatch from \(pending?.otherDog.name ?? "this dog")?",
                                isPresented: Binding(get: { pending != nil }, set: { if !$0 { pending = nil } }),
                                titleVisibility: .visible,
                                presenting: pending) { item in
                Button("Unmatch and Delete Chat", role: .destructive) {
                    Task { _ = await matchManager.unmatch(item) }
                }
                Button("Cancel", role: .cancel) {}
            } message: { _ in
                Text("The chat is deleted for both of you and you won't see each other again.")
            }
        }
    }

    private func row(_ item: MatchItem) -> some View {
        let unread = item.isUnread(for: myUid)
        return HStack(spacing: 14) {
            DogAvatar(dog: item.otherDog, size: 56)
            VStack(alignment: .leading, spacing: 3) {
                Text(item.otherDog.name).font(.headline)
                if item.match.lastMessage.isEmpty {
                    Text("Say hi to \(item.otherDog.name)!")
                        .font(.subheadline.weight(unread ? .semibold : .regular))
                        .foregroundStyle(Theme.accent)
                } else {
                    Text(item.match.lastMessage)
                        .font(.subheadline.weight(unread ? .semibold : .regular))
                        .foregroundStyle(unread ? Color.primary : Color.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
            if unread {
                Circle().fill(Theme.accent).frame(width: 10, height: 10)   // unread dot
            }
        }
        .padding(.vertical, 4)
    }
}
