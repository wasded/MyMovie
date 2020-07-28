//
//  DefaultCredentialStorage.swift
//  Coolpon.client
//
//  Created by Andrey Baskirtcev on 25.06.2020.
//  Copyright © 2020 Coolpon. All rights reserved.
//

import Foundation

class DefaultCredentialStorage: CredentialStorage {
    // MARK: - Properties
    var sessionID: String?
    var sessionIDExpiresAt: Date?
    
    // MARK: - Init
    init(sessionID: String? = nil, sessionIDExpiresAt: Date?) {
        self.sessionID = sessionID
    }
    
    // MARK: - Methods
    func setValues(sessionID: String, sessionIDExpiresAt: Date) {
        self.sessionID = sessionID
        self.sessionIDExpiresAt = sessionIDExpiresAt
    }
    
    func clearValues() {
        self.sessionID = nil
        self.sessionIDExpiresAt = nil
    }
}
