import SwiftUI

struct DogCardView: View {
    let dog: Dog
    var proximity: Proximity? = nil      // nil hides the label (own profile, or no location)

    var body: some View {
        // Color sets the 3:4 shape; the photo sits in an overlay so it can't resize the card
        Color(.secondarySystemBackground)
            .aspectRatio(3.0 / 4.0, contentMode: .fit)
            .overlay {
                if let image = ImageHelper.image(fromBase64: dog.photoData) {
                    Image(uiImage: image).resizable().scaledToFill()
                } else {
                    Image(systemName: "pawprint.fill").font(.system(size: 60)).foregroundStyle(Theme.accent)
                }
            }
            .overlay {
                // darkens the bottom so white text stays readable on any photo
                LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .center, endPoint: .bottom)
            }
            .overlay(alignment: .topTrailing) {
                if let proximity {
                    // frosted pill, an Apple material with a Google-style chip shape
                    Label(proximity.rawValue, systemImage: "location.fill")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(16)
                }
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(dog.name).font(.largeTitle.bold())
                        Text("\(dog.ageYears)").font(.title2)
                    }
                    Text("\(dog.breed) · \(dog.sex.rawValue.capitalized)").font(.headline)
                    Label(dog.city, systemImage: "mappin.and.ellipse").font(.subheadline)
                    if !dog.bio.isEmpty {
                        Text(dog.bio).font(.subheadline).lineLimit(3).padding(.top, 2)
                    }
                }
                .foregroundStyle(.white)
                .padding(20)
            }
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 16, y: 6)
    }
}
