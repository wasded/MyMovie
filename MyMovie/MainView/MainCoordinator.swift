//
//  MainCoordinator.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Error
enum MainCoordinatorError: Error {
    case noSuchTab
}

class MainCoordinator: TabBarCoordinator {
    enum Tabs: Int {
        case profile = 0
    }
    
    // MARK: - Proprties
    
    // MARK: - Init
    
    // MARK: - Methods
    override func start(with completion: @escaping () -> Void = {}) {
        super.start(with: completion)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.startTabBarCoordinator(forSelected: viewController as! UINavigationController)
    }
    
    func startTabBarCoordinator(forSelected rootVC: UINavigationController) {
        do {
            let tab = try self.tab(for: rootVC)
                self.startTab(tab)
        } catch {
            return
        }
    }
    
    private func tab(for rootVC: UINavigationController) throws -> Tabs {
        guard let tab = Tabs.init(rawValue: rootVC.tabBarItem.tag) else {
            throw MainCoordinatorError.noSuchTab
        }
        return tab
    }
    
    private func selectTab(_ tab: Tabs) {
        self.rootViewController.selectedIndex = tab.rawValue
    }
}
