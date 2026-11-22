import SwiftUI
import FirebaseAuth

struct ChatView: View {
    @Environment(AuthManager.self) private var auth
    @Environment(MatchManager.self) private var matchManager

    let item: MatchItem
    @State private var chat = ChatManager()
    @State private var draft = ""

    private var myUid: String { auth.user?.uid ?? "" }
    private var matchId: String { item.match.id ?? "" }

    // live copy of this match's unread list, so a message arriving while the chat is open gets cleared too
    private var unreadBy: [String]? {
        matchManager.matches.first(where: { $0.id == item.id })?.match.unreadBy
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 6) {
                    ForEach(chat.messages) { message in
                        MessageBubble(text: message.text, isMine: message.senderId == myUid)
                    }
                    Color.clear.frame(height: 1).id("bottom")   // anchor we scroll to
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .defaultScrollAnchor(.bottom)                       // open at the latest message
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: chat.messages.count) {
                withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
            }
        }
        .background(Theme.background)
        .safeAreaInset(edge: .bottom) { inputBar }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    DogAvatar(dog: item.otherDog, size: 30)
                    Text(item.otherDog.name).font(.headline)
                }
            }
        }
        .task {
            chat.listen(matchId: matchId)
            markReadIfNeeded()                                  // opening the chat clears the unread dot
        }
        .onChange(of: unreadBy) { markReadIfNeeded() }          // a new message while the chat is open
        .onDisappear { chat.stop() }
    }

    // text field plus a circular send button, like Messages
    private var inputBar: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField("Message", text: $draft, axis: .vertical)
                .lineLimit(1...4)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))

            Button(action: send) {
                Image(systemName: "arrow.up")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(canSend ? Theme.accent : Color.gray.opacity(0.4), in: Circle())
            }
            .disabled(!canSend)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.bar)                                       // frosted bar, an Apple material
    }

    private var canSend: Bool {
        !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func send() {
        let text = draft
        draft = ""                                              // clear immediately so it feels instant
        Task {
            await chat.send(text, matchId: matchId, senderId: myUid, recipientId: item.otherDog.ownerId)
        }
    }

    // only writes when this owner is actually in the unread list, so opening a read chat costs nothing
    private func markReadIfNeeded() {
        guard unreadBy?.contains(myUid) ?? false else { return }
        Task { await chat.markRead(matchId: matchId, myUid: myUid) }
    }
}

struct MessageBubble: View {
    let text: String
    let isMine: Bool

    var body: some View {
        HStack {
            if isMine { Spacer(minLength: 50) }
            Text(text)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .foregroundStyle(isMine ? Color.white : Color.primary)
                .background(isMine ? Theme.accent : Color(.secondarySystemFill),
                            in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            if !isMine { Spacer(minLength: 50) }
        }
    }
}
