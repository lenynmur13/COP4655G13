import SwiftUI

struct DiscoverView: View {
    @Environment(DogManager.self) private var dogs
    @Environment(SwipeManager.self) private var swipes
    @Environment(LocationManager.self) private var locationManager

    @State private var dragOffset: CGSize = .zero   // how far the top card is dragged

    private let threshold: CGFloat = 120 // drag distance that counts as a swipe

    // changes when the dog or the first location fix changes, which reloads the deck
    private var loadKey: String {
        "\(dogs.myDog?.id ?? "")-\(locationManager.location != nil)"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                if swipes.isLoading && swipes.deck.isEmpty {
                    ProgressView().controlSize(.large).frame(maxHeight: .infinity)
                } else if swipes.deck.isEmpty {
                    ContentUnavailableView {
                        Label("No more dogs for now", systemImage: "pawprint")
                    } description: {
                        Text("Check back later for new matches nearby.")
                    } actions: {
                        Button("Refresh") { Task { await reload() } }
                            .buttonStyle(TonalButtonStyle())
                            .frame(maxWidth: 200)
                    }
                } else {
                    deckView
                    HStack(spacing: 44) {
                        circleButton(symbol: "xmark", color: Theme.pass) { fling(.pass) }
                        circleButton(symbol: "heart.fill", color: Theme.like) { fling(.like) }
                    }
                }

                if let message = swipes.errorMessage {
                    Text(message).font(.footnote).foregroundStyle(.red)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { Task { await reload() } } label: { Image(systemName: "arrow.clockwise") }
                }
            }
        }
        .task(id: loadKey) { await reload() }
        .onAppear { locationManager.start() }
    }

    // up to three stacked cards; reversed so the first one is drawn last, on top
    private var deckView: some View {
        ZStack {
            ForEach(Array(swipes.deck.prefix(3).enumerated()).reversed(), id: \.element.id) { index, dog in
                let isTop = index == 0
                DogCardView(dog: dog, proximity: Proximity.between(locationManager.location, and: dog))
                    .scaleEffect(isTop ? 1 : 1 - 0.04 * CGFloat(index))   // cards behind look smaller
                    .offset(y: isTop ? 0 : 14 * CGFloat(index))
                    .overlay { if isTop { stamps } }
                    .offset(isTop ? dragOffset : .zero)
                    .rotationEffect(.degrees(isTop ? Double(dragOffset.width / 18) : 0)) // tilts as you drag
                    .gesture(dragGesture, including: isTop ? .all : .none)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: swipes.deck.first?.id)
    }

    // LIKE and PASS stamps fade in as the card moves toward either side
    private var stamps: some View {
        ZStack {
            stamp("LIKE", color: Theme.like)
                .rotationEffect(.degrees(-14))
                .opacity(Double(max(0, dragOffset.width) / threshold))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            stamp("PASS", color: Theme.pass)
                .rotationEffect(.degrees(14))
                .opacity(Double(max(0, -dragOffset.width) / threshold))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .padding(.horizontal, 24)
        .padding(.top, 70)
        .allowsHitTesting(false)
    }

    private func stamp(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.title.weight(.heavy))
            .foregroundStyle(color)
            .padding(.horizontal, 12).padding(.vertical, 4)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(color, lineWidth: 4))
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { dragOffset = $0.translation }
            .onEnded { value in
                if value.translation.width > threshold { fling(.like) }
                else if value.translation.width < -threshold { fling(.pass) }
                else { withAnimation(.spring) { dragOffset = .zero } }  // not far enough, snap back
            }
    }

    // Google-style floating circle button
    private func circleButton(symbol: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.title.weight(.bold))
                .foregroundStyle(color)
                .frame(width: 68, height: 68)
                .background(Color(.systemBackground), in: Circle())
                .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
        }
        .disabled(swipes.deck.isEmpty)
    }

    // slide the top card off screen, then record the swipe
    private func fling(_ direction: SwipeDirection) {
        guard let dog = swipes.deck.first, let myDog = dogs.myDog else { return }
        withAnimation(.easeOut(duration: 0.25)) {
            dragOffset = CGSize(width: direction == .like ? 700 : -700, height: dragOffset.height)
        } completion: {
            swipes.swipe(direction, on: dog, with: myDog)   // removes the card from the deck
            dragOffset = .zero                              // the next card starts centered
        }
    }

    private func reload() async {
        guard let myDog = dogs.myDog else { return }
        await swipes.loadDeck(for: myDog, userLocation: locationManager.location)
    }
}
