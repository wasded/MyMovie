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
    var sessionID: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.sessionID = try container.decode(String.self, forKey: .sessionID)
    }
}

extension CreateSessionResponse: Equatable { }
