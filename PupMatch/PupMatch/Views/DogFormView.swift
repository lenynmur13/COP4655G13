import SwiftUI
import FirebaseAuth

struct DogFormView: View {
    @Environment(AuthManager.self) private var auth
    @Environment(DogManager.self) private var dogs
    @Environment(LocationManager.self) private var locationManager
    @Environment(\.dismiss) private var dismiss

    let existing: Dog?                   // nil means onboarding, non-nil means editing

    @State private var name: String
    @State private var breed: String
    @State private var ageYears: Int
    @State private var sex: DogSex
    @State private var city: String
    @State private var bio: String
    @State private var photo: UIImage?
    @State private var photoChanged = false
    @State private var showPhotoSource = false

    private let breedSuggestions = ["Labrador", "Golden Retriever", "French Bulldog", "German Shepherd",
                                    "Poodle", "Chihuahua", "Husky", "Pit Bull", "Mixed"]

    init(existing: Dog?) {
        self.existing = existing
        // start the fields from the existing dog when editing
        _name = State(initialValue: existing?.name ?? "")
        _breed = State(initialValue: existing?.breed ?? "")
        _ageYears = State(initialValue: existing?.ageYears ?? 2)
        _sex = State(initialValue: existing?.sex ?? .male)
        _city = State(initialValue: existing?.city ?? "")
        _bio = State(initialValue: existing?.bio ?? "")
        _photo = State(initialValue: ImageHelper.image(fromBase64: existing?.photoData))
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
            && !breed.trimmingCharacters(in: .whitespaces).isEmpty
            && !city.trimmingCharacters(in: .whitespaces).isEmpty
            && photo != nil
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    photoBox

                    VStack(alignment: .leading, spacing: 18) {
                        OutlinedField(title: "Dog's name", text: $name)

                        VStack(alignment: .leading, spacing: 10) {
                            OutlinedField(title: "Breed", text: $breed)
                            // tap a suggestion to fill the breed field
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(breedSuggestions, id: \.self) { suggestion in
                                        Button { breed = suggestion } label: {
                                            Chip(title: suggestion, selected: breed == suggestion)
                                        }
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sex").font(.caption).foregroundStyle(.secondary).padding(.leading, 4)
                            HStack {
                                ForEach(DogSex.allCases, id: \.self) { option in
                                    Button { sex = option } label: {
                                        Chip(title: option.rawValue.capitalized, selected: sex == option)
                                    }
                                }
                            }
                        }

                        Stepper("Age: \(ageYears) \(ageYears == 1 ? "year" : "years")", value: $ageYears, in: 0...20)

                        VStack(alignment: .leading, spacing: 8) {
                            OutlinedField(title: "City", text: $city)
                            locationStatus
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("About your dog").font(.caption).foregroundStyle(.secondary).padding(.leading, 4)
                            TextEditor(text: $bio)
                                .frame(height: 100)
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color(.separator), lineWidth: 1))
                                .onChange(of: bio) { _, newValue in
                                    if newValue.count > 200 { bio = String(newValue.prefix(200)) } // 200 character cap
                                }
                            Text("\(bio.count)/200").font(.caption2).foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .card()

                    if let message = dogs.errorMessage {
                        Text(message).font(.footnote).foregroundStyle(.red)
                    }

                    Button(action: save) {
                        if dogs.isSaving { ProgressView().tint(.white) } else { Text(existing == nil ? "Create Profile" : "Save Changes") }
                    }
                    .buttonStyle(FilledButtonStyle())
                    .disabled(!isValid || dogs.isSaving)
                }
                .padding(20)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Theme.background)
            .navigationTitle(existing == nil ? "Your Dog" : "Edit Profile")
            .toolbar {
                if existing == nil {
                    // onboarding has no cancel, but the owner can still back out by signing out
                    ToolbarItem(placement: .topBarTrailing) { Button("Sign Out") { auth.signOut() } }
                } else {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                }
            }
            // camera or library, whichever the owner picks lands here
            .photoSource(isPresented: $showPhotoSource) { image in
                photo = image
                photoChanged = true
            }
            .onAppear { locationManager.start() }   // asks permission the first time, then grabs a position
        }
    }

    private var photoBox: some View {
        Button { showPhotoSource = true } label: {
            Color(.secondarySystemBackground)
                .frame(height: 300)
                .overlay {
                    if let photo {
                        Image(uiImage: photo).resizable().scaledToFill()
                    } else {
                        VStack(spacing: 10) {
                            Image(systemName: "camera.fill").font(.largeTitle)
                            Text("Add a photo of your dog").font(.subheadline.weight(.medium))
                        }
                        .foregroundStyle(Theme.accent)
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    // small floating badge when a photo is already set
                    if photo != nil {
                        Image(systemName: "camera.fill")
                            .font(.headline).foregroundStyle(.white)
                            .padding(12).background(Theme.accent, in: Circle()).padding(14)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // tells the owner whether distance labels will work for their dog
    @ViewBuilder
    private var locationStatus: some View {
        if locationManager.location != nil {
            Label("Location added, nearby owners will see how close you are", systemImage: "location.fill")
                .font(.caption).foregroundStyle(Theme.like)
        } else if locationManager.isDenied {
            Label("Location is off. Turn it on in Settings to show distance.", systemImage: "location.slash")
                .font(.caption).foregroundStyle(.secondary)
        } else {
            Label("Allow location to show how close you are", systemImage: "location")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    private func save() {
        guard let uid = auth.user?.uid else { return }
        // re-encode only when a new photo was picked, otherwise keep the stored one
        let encoded: String? = (photoChanged || existing?.photoData == nil)
            ? photo.flatMap { ImageHelper.base64(from: $0) }
            : existing?.photoData
        guard let encoded else { return }

        // fresh coordinates when we have them, otherwise keep what was saved before
        let coordinate = locationManager.location?.coordinate

        let dog = Dog(id: existing?.id, ownerId: uid,
                      name: name.trimmingCharacters(in: .whitespaces),
                      breed: breed.trimmingCharacters(in: .whitespaces),
                      ageYears: ageYears, sex: sex,
                      bio: bio.trimmingCharacters(in: .whitespacesAndNewlines),
                      city: city.trimmingCharacters(in: .whitespaces),
                      latitude: coordinate?.latitude ?? existing?.latitude,
                      longitude: coordinate?.longitude ?? existing?.longitude,
                      photoData: encoded, createdAt: existing?.createdAt)

        Task {
            if await dogs.saveDog(dog) { dismiss() } // onboarding switches screens on its own, edit sheet closes
        }
    }
}
