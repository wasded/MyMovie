//
//  TabBarCoordinator.swift
//  peopledo
//
//  Created by Pavel Ivanov on 27/03/2018.
//  Copyright © 2018 Pavel Ivanov. All rights reserved.
//

import Foundation
import UIKit

open class TabBarCoordinator:UIResponder, Coordinating, UITabBarControllerDelegate {
    public let rootViewController: UITabBarController
    
    public init(rootViewController: UITabBarController?) {
        guard let rvc = rootViewController else {
            fatalError("Must supply UIViewController (or any of its subclasses) or override this init and instantiate VC in there.")
        }
        self.rootViewController = rvc
        super.init()
    }
    
    open lazy var identifier: String = {
        return String(describing: type(of: self))
    }()
    
    open weak var parent: Coordinating?
    
    ///    A dictionary of child Coordinators, where key is Coordinator's identifier property
    ///    The only way to add/remove something is through startChild/stopChild methods
    fileprivate(set) public var childCoordinators: [String: Coordinating] = [:]
    
    open override var coordinatingResponder: UIResponder? {
        return parent as? UIResponder
    }
    
    /// Tells the coordinator to create/display its initial view controller and take over the user flow.
    ///    Use this method to configure your `rootViewController` (if it isn't already).
    ///    Some examples:
    ///    * instantiate and assign `viewControllers` for UINavigationController or UITabBarController
    ///    * assign itself (Coordinator) as delegate for the shown UIViewController(s)
    ///    * setup closure entry/exit points
    ///    etc.
    ///
    ///    - Parameter completion: An optional `Callback` executed at the end.
    open func start(with completion: @escaping () -> Void = {}) {
        rootViewController.delegate = self
        rootViewController.parentCoordinator = self
        completion()
    }
    
    /// Tells the coordinator that it is done and that it should
    ///    rewind the view controller state to where it was before `start` was called.
    ///    That means either dismiss presented controller or pop pushed ones.
    ///
    ///    - Parameter completion: An optional `Callback` executed at the end.
    open func stop(with completion: @escaping () -> Void = {}) {
        rootViewController.parentCoordinator = nil
        completion()
    }
    
    open func coordinatorDidFinish(_ coordinator: Coordinating, completion: @escaping () -> Void = {}) {
        stopChild(coordinator: coordinator, completion: completion)
    }
    
    ///    Coordinator can be in memory, but it‘s not currently displaying anything.
    ///    For example, parentCoordinator started some other Coordinator which then took over root VC to display its VCs,
    ///    but did not stop this one.
    ///
    ///    Parent Coordinator can then re-activate this one, in which case it should take-over the
    ///    the ownership of the root VC.
    open func activate() {
        rootViewController.parentCoordinator = self
    }
    
    open func isHiddenTabBar(_ isHidden: Bool) {
        rootViewController.tabBar.isHidden = isHidden
    }
    
    public func addTabCoordinator<E: RawRepresentable, T: UIViewController>(coordinator:Coordinator<T>, tab:E) where E.RawValue == Int {
        self.addChild(coordinator: coordinator)
        coordinator.rootViewController.tabBarItem.tag = tab.rawValue
        if (self.rootViewController.viewControllers == nil) {
            self.rootViewController.viewControllers = [coordinator.rootViewController]
        } else {
            self.rootViewController.viewControllers?.append(coordinator.rootViewController)
        }
    }
    
    /**
     Adds new child coordinator and starts it.
     
     - Parameter coordinator: The coordinator implementation to start.
     - Parameter completion: An optional `Callback` passed to the coordinator's `start()` method.
     
     - Returns: The started coordinator.
     */
    public func startChild(coordinator: Coordinating, completion: @escaping () -> Void = {}) {
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.parent = self
        coordinator.start(with: completion)
    }
    
    public func startTab<E: RawRepresentable>(_ tab:E, completion: @escaping () -> Void = {}) where E.RawValue == Int {
        for child in self.childCoordinators.values {
            if let coordinatorChild = child as? NavigationCoordinator {
                if coordinatorChild.rootViewController.tabBarItem.tag == tab.rawValue {
                    coordinatorChild.start(with: completion)
                }
            }
        }
    }
    
    private func addChild(coordinator: Coordinating) {
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.parent = self
    }
    
    /**
     Stops the given child coordinator and removes it from the `childCoordinators` array
     
     - Parameter coordinator: The coordinator implementation to stop.
     - Parameter completion: An optional `Callback` passed to the coordinator's `stop()` method.
     */
    public func stopChild(coordinator: Coordinating, completion: @escaping () -> Void = {}) {
        coordinator.parent = nil
        coordinator.stop {
            [unowned self] in
            
            self.childCoordinators.removeValue(forKey: coordinator.identifier)
            completion()
        }
    }
    
    func showContentFor(cordinator:Coordinating) {
        let identifier = String(describing: type(of:cordinator).self)
        if childCoordinators[identifier] == nil {
            startChild(coordinator: cordinator, completion: {})
        }
    }
}
