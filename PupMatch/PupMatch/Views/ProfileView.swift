import SwiftUI

struct ProfileView: View {
    @Environment(AuthManager.self) private var auth
    @Environment(DogManager.self) private var dogs
    @State private var showEdit = false
    @State private var showDelete = false
    @State private var password = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let dog = dogs.myDog { DogCardView(dog: dog) }

                    // owner info block
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Owner").font(.caption).foregroundStyle(.secondary)
                        Text(auth.owner?.displayName ?? "").font(.headline)
                        Text(auth.owner?.email ?? "").font(.subheadline).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .card()

                    Button("Edit Dog Profile") { showEdit = true }
                        .buttonStyle(TonalButtonStyle())

                    if let message = auth.errorMessage {
                        Text(message).font(.footnote).foregroundStyle(.red)
                    }

                    VStack(spacing: 14) {
                        Button("Sign Out", role: .destructive) { auth.signOut() }
                        Button("Delete Account", role: .destructive) { showDelete = true }
                            .font(.footnote)
                    }
                    .padding(.top, 4)
                }
                .padding(20)
            }
            .background(Theme.background)
            .navigationTitle("Profile")
        }
        .sheet(isPresented: $showEdit) { DogFormView(existing: dogs.myDog) }
        // the alert asks for the password because Firebase needs a fresh login to delete an account
        .alert("Delete your account?", isPresented: $showDelete) {
            SecureField("Password", text: $password)
            Button("Delete", role: .destructive) {
                let entered = password
                password = ""
                Task { _ = await auth.deleteAccount(password: entered) }
            }
            Button("Cancel", role: .cancel) { password = "" }
        } message: {
            Text("This permanently deletes your dog's profile, your matches, and your chats. Enter your password to confirm.")
        }
    }
}
