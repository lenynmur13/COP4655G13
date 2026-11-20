//
//  Message.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/19/26.
//

import Foundation
import FirebaseFirestore

struct Message: Codable, Identifiable {
    @DocumentID var id: String?
    var senderId: String
    var text: String
    @ServerTimestamp var timestamp: Date?
}
