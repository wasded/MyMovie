//
//  UserCredential.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

struct UserCredential: Codable {
    var sessionID: String
    var sessionIDExpiresAt: Date
    
    enum CodingKeys: String, CodingKey {
        case sessionID = "session_id"
        case sessionIDExpiresAt
    }
}
