// AppDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// AppDelegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let token = "K7GHQAS-E64MB8F-GKDJMF4-NTV0J0C"
        if KeychainService.instance.getToken() == nil {
            KeychainService.instance.setToken(token: token)
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
