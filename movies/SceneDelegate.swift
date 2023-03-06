//
//  SceneDelegate.swift
//  movies
//
//  Created by Oleksandr Khalypa on 31.01.2023.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import AppsFlyerLib

import FacebookCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navController = UINavigationController()
        coordinator = AppCoordinator(navigationController: navController)
        self.coordinator?.start()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        AppsFlyerLib.shared().start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.requestPermission()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            _ = appDelegate.application(UIApplication.shared, open: url, options: [:])
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func requestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Authorized Tracking Permission")
                case .denied:
                    print("Denied Tracking Permission")
                case .notDetermined:
                    print("Not Determined Tracking Permission")
                case .restricted:
                    print("Restricted Tracking Permission")
                @unknown default:
                    print("Unknown Tracking Permission")
                }
            }
        }
    }


}

