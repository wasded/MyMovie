//
//  AppCoordinator.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit
import Resolver

class AppCoordinator: NavigationCoordinator {
    // MARK: - Properties
    @Injected var sessionManager: SessionManager
    
    // MARK: - Init
    init(rootViewController: UINavigationController?, sessionManager: SessionManager) {
        super.init(rootViewController: rootViewController)
        self.sessionManager = sessionManager
    }
    
    // MARK: - Methods
    override func start(with completion: @escaping () -> Void) {
        self.startMainCoordinator()
        super.start(with: completion)
    }
    
    func startMainCoordinator() {
        self.sessionManager.start()
        let tabBarController = UITabBarController()
        let mainCooridnator = MainCoordinator(rootViewController: tabBarController)
        self.startChild(coordinator: mainCooridnator) {
            self.root(tabBarController)
        }
    }
}
