//
//  NavigationCoordinator.swift
//  Radiant Tap Essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

open class NavigationCoordinator: Coordinator<UINavigationController>, UINavigationControllerDelegate {
    //	this keeps the references to actual UIViewControllers managed by this Coordinator only
    open var viewControllers: [UIViewController] = []
    
    public override init(rootViewController: UINavigationController?) {
        super.init(rootViewController: rootViewController)
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.transitionCoordinator?.isInteractive == false {
            let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from)
            self.willShowController(viewController, fromViewController: fromViewController)
        } else {
            navigationController.transitionCoordinator?.notifyWhenInteractionChanges {
                [unowned self] context in
                guard !context.isInteractive else { return }
                guard !context.isCancelled else { return }
                let fromViewController = context.viewController(forKey: .from)
                self.willShowController(viewController, fromViewController: fromViewController)
            }
        }
    }
    
    public func present(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        rootViewController.present(vc, animated: animated, completion: completion)
    }
    
    public func dismiss(completion: (() -> Void)? = nil) {
        if rootViewController.presentedViewController == nil {
            completion?()
        } else {
            rootViewController.dismiss(animated: true, completion: completion)
        }
    }
    
    public func show(_ vc: UIViewController) {
        viewControllers.append(vc)
        rootViewController.show(vc, sender: self)
    }
    
    public func root(_ vc: UIViewController) {
        viewControllers = [vc]
        rootViewController.viewControllers = [vc]
    }
    
    public func root(_ vcs: [UIViewController]) {
        viewControllers = vcs
        rootViewController.viewControllers = vcs
    }
    
    public func top(_ vc: UIViewController) {
        if viewControllers.count == 0 {
            root(vc)
            return
        }
        viewControllers.removeLast()
        rootViewController.viewControllers.removeLast()
        show(vc)
    }
    
    
    public func pop(to vc: UIViewController, animated: Bool = true) {
        rootViewController.popToViewController(vc, animated: animated)
        
        if let index = viewControllers.index(of: vc) {
            let lastPosition = viewControllers.count - 1
            if lastPosition > 0 {
                viewControllers = Array(viewControllers.dropLast(lastPosition - index))
            }
        }
    }
    
    /// Pops back to previous UIVC in the stack, inside this Coordinator.
    public func pop(animated: Bool = true) {
        // there must be at least two VCs in order for UINC.pop to succeed (you can't pop the last VC in the stack)
        if viewControllers.count < 2 {
            return
        }
        viewControllers = Array(viewControllers.dropLast())
        
        rootViewController.popViewController(animated: animated)
    }
    
    open func handlePopBack(to vc: UIViewController?) {
    }
    
    open override func start(with completion: @escaping () -> Void) {
        rootViewController.delegate = self
        super.start(with: completion)
    }
    
    open override func stop(with completion: @escaping () -> Void) {
        rootViewController.delegate = nil
        
        for vc in viewControllers {
            guard let index = rootViewController.viewControllers.index(of: vc) else { continue }
            rootViewController.viewControllers.remove(at: index)
        }
        
        viewControllers.removeAll()
        
        super.stop(with: completion)
    }
    
    open override func activate() {
        //	take ownership over UINavigationController
        super.activate()
        //	assign itself again as UINavigationControllerDelegate
        rootViewController.delegate = self
        //	re-assign own content View Controllers
        rootViewController.viewControllers = viewControllers
    }
    
    open func stopChildBySettingViewControllersAndActivateSelf(coordinator: Coordinating, newViewControllers:[UIViewController], animated: Bool, with completion: @escaping () -> Void) {
        self.viewControllers = newViewControllers
        rootViewController.delegate = self
        rootViewController.parentCoordinator = self
        rootViewController.setViewControllers(newViewControllers, animated: animated)
        coordinator.parent = nil
        self.removeChildCoordinator(id: coordinator.identifier)
        completion()
    }
    
    open func stopChildWithShowingViewControllerAndActivateSelf(coordinator: Coordinating, newViewController:UIViewController, animated: Bool, with completion: @escaping () -> Void) {
        var newNavigationViewControllers = self.rootViewController.viewControllers
        
        if let latestViewController = self.viewControllers.last,
            let index = newNavigationViewControllers.index(of: latestViewController) {
            let range = index+1...newNavigationViewControllers.count-1
            newNavigationViewControllers.removeSubrange(range)
            newNavigationViewControllers.append(newViewController)
            self.viewControllers.append(newViewController)
        }
        
        rootViewController.delegate = self
        rootViewController.parentCoordinator = self
        rootViewController.setViewControllers(newNavigationViewControllers, animated: animated)
        coordinator.parent = nil
        self.removeChildCoordinator(id: coordinator.identifier)
        completion()
    }
    
    
    open func removeViewControllersFromHierachy(startViewController: UIViewController, newViewController: UIViewController, with completion: @escaping () -> Void) {
        var rootViewControllers = self.rootViewController.viewControllers
        for i in stride(from: rootViewControllers.count-1, through: 0, by: -1) {
            if rootViewControllers[i] === startViewController, rootViewControllers[i].parentCoordinator === startViewController.parentCoordinator {
                break
            } else {
                rootViewControllers.remove(at: i)
            }
        }
        
        for i in stride(from: self.viewControllers.count-1, through: 0, by: -1) {
            if self.viewControllers[i] === startViewController, self.viewControllers[i].parentCoordinator === startViewController.parentCoordinator {
                break
            } else {
                self.viewControllers.remove(at: i)
            }
        }
        
        self.viewControllers.append(newViewController)
        rootViewControllers.append(newViewController)
        self.rootViewController.setViewControllers(rootViewControllers, animated: true)
        completion()
    }
    
}

fileprivate extension NavigationCoordinator {
    func willShowController(_ viewController: UIViewController, fromViewController: UIViewController?) {
        guard let fromViewController = fromViewController else { return }
        
        //        if !viewControllers.contains( viewController ) { return }
        
        //	check is this pop:
        if let vc = self.viewControllers.last, vc === fromViewController {
            //	this is pop. remove this controller from Coordinator's list
            self.viewControllers.removeLast()
            self.handlePopBack(to: self.viewControllers.last)
        }
        //	is there any controller left shown?
        if self.viewControllers.count == 0 {
            //	inform the parent Coordinator that this child Coordinator has no more views
            self.parent?.coordinatorDidFinish(self, completion: {})
            return
        }
    }
}


