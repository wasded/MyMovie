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
    var expiresAt: Date
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case token = "request_token"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYT-MM-DD hh:mm:ss"
        
        let expiresAt = try container.decode(String.self, forKey: .expiresAt)
        
        self.expiresAt = dateFormatter.date(from: expiresAt) ?? Date()
        
        self.token = try container.decode(String.self, forKey: .token)
    }
}

extension CreateSessionResponse: Equatable { }
