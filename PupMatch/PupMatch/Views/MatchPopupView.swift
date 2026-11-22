import SwiftUI

// round dog photo with a white ring
struct DogAvatar: View {
    let dog: Dog?
    var size: CGFloat = 56

    var body: some View {
        Group {
            if let image = ImageHelper.image(fromBase64: dog?.photoData) {
                Image(uiImage: image).resizable().scaledToFill()
            } else {
                Image(systemName: "pawprint.fill").foregroundStyle(Theme.accent)
            }
        }
        .frame(width: size, height: size)
        .background(Color(.secondarySystemBackground))
        .clipShape(Circle())
        .overlay(Circle().stroke(.white, lineWidth: size > 100 ? 5 : 2))
    }
}

struct MatchPopupView: View {
    let myDog: Dog?
    let otherDog: Dog
    let onMessage: () -> Void
    let onClose: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.accent, Color(hex: 0xFF9E80)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()
                Text("It's a Match!")
                    .font(.system(size: 42, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                Text("\(myDog?.name ?? "Your dog") and \(otherDog.name) liked each other")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)

                // two tilted photos with a heart between them
                ZStack {
                    HStack(spacing: -34) {
                        DogAvatar(dog: myDog, size: 150).rotationEffect(.degrees(-8))
                        DogAvatar(dog: otherDog, size: 150).rotationEffect(.degrees(8))
                    }
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundStyle(Theme.pass)
                        .padding(14)
                        .background(.white, in: Circle())
                        .shadow(color: .black.opacity(0.2), radius: 8, y: 3)
                }
                .scaleEffect(appeared ? 1 : 0.3)
                .opacity(appeared ? 1 : 0)
                .padding(.vertical, 12)

                Spacer()

                VStack(spacing: 12) {
                    Button(action: onMessage) {
                        Text("Send a Message")
                            .font(.headline).foregroundStyle(Theme.accent)
                            .frame(maxWidth: .infinity).padding(.vertical, 15)
                            .background(.white, in: Capsule())
                    }
                    Button(action: onClose) {
                        Text("Keep Swiping")
                            .font(.headline).foregroundStyle(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 15)
                            .overlay(Capsule().stroke(.white, lineWidth: 2))
                    }
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 28)
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.6)) { appeared = true }
        }
    }
}
