//
//  BackendAuthorizationController.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Combine

protocol BackendAuthorizationController: class {
    func createRequestToken() -> AnyPublisher<CreateRequestTokenResponse, Error>
    func createSession(requestToken: String) -> AnyPublisher<CreateSessionResponse, Error>
    func deleteSession(sessionID: String) -> AnyPublisher<DeleteSessionResponse, Error>
}
