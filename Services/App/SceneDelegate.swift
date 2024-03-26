//
//  SceneDelegate.swift
//  Services
//
//  Created by Эльдар Абдуллин on 26.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let startVC = ServicesViewController()
        let navigationControllerVC = UINavigationController(rootViewController: startVC)

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationControllerVC
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
    }
}
