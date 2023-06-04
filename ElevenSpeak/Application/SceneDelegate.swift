// SceneDelegate.swift
// ElevenSpeak. Created by Bogdan Bystritskiy.

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let idProvider: () -> String
    let dateProvider: () -> Date

    override init() {
        idProvider = {
            UUID().uuidString
        }
        dateProvider = Date.init
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let rootView = MainView(idProvider: idProvider)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: rootView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
