//
//  CreditnialStorage.swift
//  Coolpon.client
//
//  Created by Andrey Baskirtcev on 25.06.2020.
//  Copyright © 2020 Coolpon. All rights reserved.
//

import Foundation

protocol CredentialStorageOutput: class {
    var sessionID: String? { get }
    var sessionIDExpiresAt: Date? { get }
}

protocol CredentialStorageInput {
    func setValues(sessionID: String, sessionIDExpiresAt: Date)
    func clearValues()
}

typealias CredentialStorage = CredentialStorageOutput & CredentialStorageInput
