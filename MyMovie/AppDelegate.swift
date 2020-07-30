//
//  AppDelegate.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import UIKit
import Resolver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, Resolving {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerDependencies()
        
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
        
        let defaultBackendController = DefaultBackendController(networkWorker: Resolver.resolve(), credentialStorage: Resolver.resolve())
        resolver.register { defaultBackendController as BackendAuthorizationController}.scope(Resolver.application)
        resolver.register { defaultBackendController as BackendDiscoverController}.scope(Resolver.application)
        
        resolver.register { DefaultSessionManager(backendController: self.resolver.resolve(), credentialStorage: self.resolver.resolve()) as SessionManager}.scope(Resolver.application)
    }
}

