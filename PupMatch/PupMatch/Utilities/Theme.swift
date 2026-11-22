//
//  Theme.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/22/26.
//

import SwiftUI

extension Color {
    // build a color from a hex number like 0xFF7043
    init(hex: UInt32) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: 1)
    }
}

enum Theme {
    static let accent = Color(hex: 0xFF7043)                 // warm coral
    static let accentSoft = Color(hex: 0xFF7043).opacity(0.14) // tonal container behind accent text
    static let like = Color(hex: 0x34A853)                   // Google green, used for like
    static let pass = Color(hex: 0xEA4335)                   // Google red, used for pass
    static let background = Color(.systemGroupedBackground)
    static let card = Color(.secondarySystemGroupedBackground)
    static let corner: CGFloat = 20
}

// Material-style filled button: full width, pill shaped, dims when disabled
struct FilledButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .foregroundStyle(.white)
            .background(isEnabled ? Theme.accent : Color.gray.opacity(0.4), in: Capsule())
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// Material-style tonal button: soft tinted pill for secondary actions
struct TonalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .foregroundStyle(Theme.accent)
            .background(Theme.accentSoft, in: Capsule())
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension View {
    // rounded grouped card with a soft shadow, the base surface for forms and info blocks
    func card() -> some View {
        self.padding(16)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.corner, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }
}

// outlined text field with the label above it, Material style
struct OutlinedField: View {
    let title: String
    @Binding var text: String
    var secure = false
    var keyboard: UIKeyboardType = .default
    var capitalization: TextInputAutocapitalization = .sentences

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.caption).foregroundStyle(.secondary).padding(.leading, 4)
            Group {
                if secure { SecureField("", text: $text) } else { TextField("", text: $text) }
            }
            .keyboardType(keyboard)
            .textInputAutocapitalization(capitalization)
            .autocorrectionDisabled(keyboard == .emailAddress || secure)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color(.separator), lineWidth: 1)
            )
        }
    }
}

// pill chip for choices and suggestions; tinted when selected
struct Chip: View {
    let title: String
    let selected: Bool

    var body: some View {
        Text(title)
            .font(.subheadline.weight(.medium))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundStyle(selected ? Theme.accent : Color.primary)
            .background(selected ? Theme.accentSoft : Color(.tertiarySystemFill), in: Capsule())
            .overlay(Capsule().stroke(selected ? Theme.accent : Color.clear, lineWidth: 1))
    }
}
