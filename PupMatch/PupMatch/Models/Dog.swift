import Foundation
import FirebaseFirestore

enum DogSex: String, Codable, CaseIterable {
    case male, female
}

struct Dog: Codable, Identifiable {
    @DocumentID var id: String?
    var ownerId: String                  // uid of the owner
    var name: String
    var breed: String
    var ageYears: Int
    var sex: DogSex
    var bio: String
    var city: String
    var latitude: Double?                // saved from the owner's location; nil if location was off
    var longitude: Double?
    var photoData: String?               // base64 JPEG, since we skipped Storage
    @ServerTimestamp var createdAt: Date?
}
