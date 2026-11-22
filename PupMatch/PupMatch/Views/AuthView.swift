import SwiftUI

struct AuthView: View {
    @Environment(AuthManager.self) private var auth
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var city = ""

    private var isValid: Bool {
        let base = email.contains("@") && password.count >= 6
        return isSignUp ? base && !displayName.isEmpty && !city.isEmpty : base
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // app icon style header
                VStack(spacing: 12) {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 44)).foregroundStyle(.white)
                        .frame(width: 88, height: 88)
                        .background(Theme.accent, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                    Text("PupMatch").font(.largeTitle.bold())
                    Text("Find the perfect match for your pup").foregroundStyle(.secondary)
                }
                .padding(.top, 40)

                // Apple-style segmented switch between the two modes
                Picker("Mode", selection: $isSignUp) {
                    Text("Log In").tag(false)
                    Text("Sign Up").tag(true)
                }
                .pickerStyle(.segmented)

                VStack(spacing: 16) {
                    if isSignUp {
                        OutlinedField(title: "Your name", text: $displayName)
                        OutlinedField(title: "City", text: $city)
                    }
                    OutlinedField(title: "Email", text: $email, keyboard: .emailAddress, capitalization: .never)
                    OutlinedField(title: "Password (6+ characters)", text: $password, secure: true, capitalization: .never)
                }
                .card()

                if let message = auth.errorMessage {
                    Text(message).font(.footnote).foregroundStyle(.red)
                }

                Button {
                    Task {
                        if isSignUp {
                            await auth.signUp(email: email, password: password, displayName: displayName, city: city)
                        } else {
                            await auth.signIn(email: email, password: password)
                        }
                    }
                } label: {
                    if auth.isLoading { ProgressView().tint(.white) } else { Text(isSignUp ? "Create Account" : "Log In") }
                }
                .buttonStyle(FilledButtonStyle())
                .disabled(!isValid || auth.isLoading)
            }
            .padding(.horizontal, 20)
            .animation(.easeInOut(duration: 0.2), value: isSignUp)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Theme.background)
        .onChange(of: isSignUp) { auth.errorMessage = nil } // clear stale errors when switching modes
    }
}
