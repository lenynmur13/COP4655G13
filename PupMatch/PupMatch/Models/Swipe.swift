//
//  Swipe.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/19/26.
//

import Foundation
import FirebaseFirestore

enum SwipeDirection: String, Codable {
    case like, pass
}

struct Swipe: Codable, Identifiable {
    @DocumentID var id: String?          // we set this to "fromDog_toDog" so a swipe can't duplicate
    var fromDog: String
    var toDog: String
    var fromOwner: String
    var toOwner: String                  // lets the Likes tab query incoming likes directly
    var direction: SwipeDirection
    @ServerTimestamp var createdAt: Date?
}
