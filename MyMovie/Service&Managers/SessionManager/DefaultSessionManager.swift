//
//  DefaultSessionManager.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Resolver
import Combine

enum SessionManagerError: Error, LocalizedError {
    case noSessionID
}

class DefaultSessionManager: SessionManager {
    // MARK: - Proprties
    @Injected var backendController: BackendAuthorizationController
    @Injected var credentialStorage: CredentialStorage
    
    private let userDefaults = UserDefaults.standard
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    private var requestToken: String? = nil
    
    var sessionState: SessionState = .unnowned {
        didSet {
            if oldValue != self.sessionState {
                self.sessionStateDidChanged(self.sessionState)
            }
        }
    }
    
    private var observers = NSHashTable<AnyObject>.weakObjects()
    
    // MARK: - Init
    init(backendController: BackendAuthorizationController, credentialStorage: CredentialStorage) {
        self.backendController = backendController
        self.credentialStorage = credentialStorage
    }
    
    // MARK: - Methods
    func start() {
    }
    
    func authorize() -> AnyPublisher<CreateSessionResponse, Error> {
        return self.backendController.createRequestToken().flatMap { (response) in
            return self.backendController.createSession(requestToken: response.token)
        }
        .handleEvents(receiveOutput: { (response) in
            self.credentialStorage.setValues(sessionID: response.token, sessionIDExpiresAt: response.expiresAt)
        })
        .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<DeleteSessionResponse, Error> {
        if let sessionID = self.credentialStorage.sessionID {
            return self.backendController.deleteSession(sessionID: sessionID)
        } else {
            return Fail(error: SessionManagerError.noSessionID).eraseToAnyPublisher()
        }
    }
    
    // MARK: - Observer
    func addObserver(subscriber: SessionManagerObserver) {
        self.observers.add(subscriber)
    }
    
    func removeOserver(subscriber: SessionManagerObserver) {
        self.observers.remove(subscriber)
    }
    
    func sessionStateDidChanged(_ sessionState: SessionState) {
        for item in self.observers.allObjects {
            if let subscriber = item as? SessionManagerObserver {
                subscriber.sessionManagerDidUpdateState(sessionState)
            }
        }
    }
}
