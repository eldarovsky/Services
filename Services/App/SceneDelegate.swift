//
//  SceneDelegate.swift
//  Services
//
//  Created by Эльдар Абдуллин on 26.03.2024.
//

import UIKit

// MARK: - Scene Delegate
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: Public Properties
    var window: UIWindow?

    // MARK: Public Methods
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let servicesVC = ServicesViewController()
        let navigationControllerVC = UINavigationController(rootViewController: servicesVC)

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationControllerVC
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
    }
}
