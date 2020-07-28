//
//  DeeplinkSupporter.swift
//  peopledo
//
//  Created by Pavel Ivanov on 09/04/2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import Foundation

protocol LinkHandler {
    var supportedActions:[String] { get }
    func goWith(path: String)
    func handle(action: String, path: String?)
    func canHandle(action: String) -> Bool
    func canHandle(path: String) -> Bool
}

extension LinkHandler {
    func goWith(path: String) {
        guard self.canHandle(path: String(path)) else { return }
        let elements = path.split(separator: "/", maxSplits: 1, omittingEmptySubsequences: true)
        guard let action = elements.first else { return }
        
        var path:String?
        if elements.count > 1 {
            path = String(elements[1])
        }
        
        self.handle(action: String(action), path: path)
    }
    
    func canHandle(path: String) -> Bool {
        let elements = path.split(separator: "/", maxSplits: 1, omittingEmptySubsequences: true)
        guard let action = elements.first else { return false }
        return self.canHandle(action: String(action))
    }
    
    func canHandle(action: String) -> Bool {
        return self.supportedActions.contains(action)
    }
}
