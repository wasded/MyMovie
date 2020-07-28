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
    var userCredential: UserCredential?
    
    // MARK: - Init
    init(userCredential: UserCredential? = nil) {
        self.userCredential = userCredential
    }
    
    // MARK: - Methods
    func setValues(sessionID: String) {
        self.userCredential = UserCredential(sessionID: sessionID)
    }
    
    func setValue(userCredential: UserCredential) {
        self.userCredential = userCredential
    }
    
    func clearValues() {
        self.userCredential = nil
    }
}
