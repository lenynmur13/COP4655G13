//
//  Owner.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/19/26.
//

import Foundation
import FirebaseFirestore

struct Owner: Codable, Identifiable {
    @DocumentID var id: String?          // doc ID = Firebase Auth uid
    var email: String
    var displayName: String
    var city: String
    @ServerTimestamp var createdAt: Date? // filled by the server on write
}
