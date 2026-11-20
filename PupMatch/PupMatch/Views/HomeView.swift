//
//  HomeView.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/19/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(AuthManager.self) private var auth

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome, \(auth.owner?.displayName ?? "...")").font(.title).bold()
            Text(auth.owner?.city ?? "")
            Button("Sign Out") { auth.signOut() }
                .buttonStyle(.bordered)
        }
        .padding()
    }
}
