//
//  CreditnialStorage.swift
//  Coolpon.client
//
//  Created by Andrey Baskirtcev on 25.06.2020.
//  Copyright © 2020 Coolpon. All rights reserved.
//

import Foundation

protocol CredentialStorageOutput: class {
    var userCredential: UserCredential? { get }
}

protocol CredentialStorageInput {
    func setValues(sessionID: String)
    func setValue(userCredential: UserCredential)
    func clearValues()
}

typealias CredentialStorage = CredentialStorageOutput & CredentialStorageInput
