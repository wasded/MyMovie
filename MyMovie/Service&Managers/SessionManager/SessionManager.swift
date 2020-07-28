//
//  SessionManager.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Combine

enum SessionState {
    case unnowned
    case anonimouse
    case authorized
}

extension SessionState: Equatable { }

protocol SessionManagerObserver: AnyObject {
    func sessionManagerDidUpdateState(_ sessionState: SessionState)
    func userDidLoggedOut()
}

extension SessionManagerObserver {
    func sessionManagerDidUpdateState(sessionState: SessionState) { }
    func userDidLoggedOut() { }
}

protocol SessionManager: class {
    var sessionState: SessionState { get }
    
    func start()
    
    func authorize() -> AnyPublisher<CreateSessionResponse, Error>
    func logout() -> AnyPublisher<DeleteSessionResponse, Error>
    
    func addObserver(subscriber: SessionManagerObserver)
    func removeOserver(subscriber: SessionManagerObserver)
}
