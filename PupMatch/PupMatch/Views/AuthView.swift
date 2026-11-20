//
//  AuthView.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/19/26.
//

import SwiftUI

struct AuthView: View {
    @Environment(AuthManager.self) private var auth
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var city = ""

    // simple client-side check; Firebase enforces the 6-character minimum anyway
    private var isValid: Bool {
        let base = email.contains("@") && password.count >= 6
        return isSignUp ? base && !displayName.isEmpty && !city.isEmpty : base
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("PupMatch").font(.largeTitle).bold()
            Text(isSignUp ? "Create your account" : "Welcome back")
                .foregroundStyle(.secondary)

            if isSignUp {
                TextField("Your name", text: $displayName).textFieldStyle(.roundedBorder)
                TextField("City", text: $city).textFieldStyle(.roundedBorder)
            }

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            SecureField("Password (6+ characters)", text: $password)
                .textFieldStyle(.roundedBorder)

            if let message = auth.errorMessage {
                Text(message).font(.footnote).foregroundStyle(.red)
            }

            Button {
                Task {
                    if isSignUp {
                        await auth.signUp(email: email, password: password,
                                          displayName: displayName, city: city)
                    } else {
                        await auth.signIn(email: email, password: password)
                    }
                }
            } label: {
                // spinner replaces the label while the request runs
                if auth.isLoading { ProgressView() } else { Text(isSignUp ? "Sign Up" : "Log In") }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isValid || auth.isLoading)

            Button(isSignUp ? "Already have an account? Log in" : "New here? Create an account") {
                isSignUp.toggle()
                auth.errorMessage = nil  // clear stale errors when switching modes
            }
            .font(.footnote)
        }
        .padding()
    }
}
