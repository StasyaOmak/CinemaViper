// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var appCoordinator: AppCoordinator?
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setupWindow(scene: scene)
    }

    private func setupWindow(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        if let window {
            window.makeKeyAndVisible()
            let builder = AppBuilder()
            appCoordinator = AppCoordinator(appBuilder: builder)
            appCoordinator?.start()
        }
    }
}
