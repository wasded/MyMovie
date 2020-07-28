//
//  AppDelegate.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import UIKit
import Combine
import Resolver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, Resolving {
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerDependencies()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController()
        self.window?.rootViewController?.view.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        self.appCoordinator = AppCoordinator(rootViewController: self.window?.rootViewController as! UINavigationController, sessionManager: Resolver.resolve())
        self.appCoordinator.start { }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func registerDependencies() {
        resolver.register { DefaultNetworkWorker() as NetworkWorker}.scope(Resolver.application)
        resolver.register { DefaultCredentialStorage() as CredentialStorage}.scope(Resolver.application)
        resolver.register { DefaultBackendController(networkWorker: self.resolver.resolve(), credentialStorage: self.resolver.resolve()) as BackendAuthorizationController}.scope(Resolver.application)
        resolver.register { DefaultSessionManager(backendController: self.resolver.resolve(), credentialStorage: self.resolver.resolve()) as SessionManager}.scope(Resolver.application)
    }
}

