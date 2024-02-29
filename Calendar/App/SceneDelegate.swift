//
//  SceneDelegate.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.rootViewController = MainViewController(nibName: nil, bundle: nil)
        window?.makeKeyAndVisible()
    }
}
