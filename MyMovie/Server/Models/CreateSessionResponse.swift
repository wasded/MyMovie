//
//  CreateSessionResponse.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

struct CreateSessionResponse: Codable {
    var success: Bool
    var expiresAt: String
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case token = "request_token"
    }
}

extension CreateSessionResponse: Equatable { }
