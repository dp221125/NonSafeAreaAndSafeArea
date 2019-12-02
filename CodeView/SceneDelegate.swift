//
//  SceneDelegate.swift
//  CodeView
//
//  Created by Seokho on 2019/11/28.
//  Copyright © 2019 Seokho. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow()
        window.windowScene = windowScene
        self.window = window
        self.window?.rootViewController = MainViewController()
        self.window?.makeKeyAndVisible()
    }
}

