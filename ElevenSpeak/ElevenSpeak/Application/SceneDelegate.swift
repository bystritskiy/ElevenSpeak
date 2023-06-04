// SceneDelegate.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: ChatView())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
