//
//  Match.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/19/26.
//

import Foundation
import FirebaseFirestore

struct Match: Codable, Identifiable {
    @DocumentID var id: String?          // sorted "dogA_dogB" so each pair has one match
    var participants: [String]           // the two owner uids, used by security rules and queries
    var dogs: [String]                   // the two dog IDs
    var lastMessage: String
    var lastMessageTime: Date?
}
