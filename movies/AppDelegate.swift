//
//  AppDelegate.swift
//  movies
//
//  Created by Oleksandr Khalypa on 31.01.2023.
//

import UIKit
import TikTokOpenSDK
import OneSignal
import AppsFlyerLib
import AppTrackingTransparency
import FacebookCore
import FBSDKCoreKit
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // TIkTok
        TikTokOpenSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        TikTokOpenSDKApplicationDelegate.sharedInstance().logDelegate = self
        
        // OneSignal
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("YOUR_ONESIGNAL_APP_ID")
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // AppsFlyer
        AppsFlyerLib.shared().appsFlyerDevKey = "appsFlyerDevKey"
        AppsFlyerLib.shared().appleAppID = "appleAppID"
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        AppsFlyerLib.shared().delegate = self
        NotificationCenter.default.addObserver(self, selector: NSSelectorFromString("sendLaunch"), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
        // Initialize Facebook SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Get user's Facebook attribution data
        AppEvents.activateApp()
        
        return true
    }
    
    @objc func sendLaunch() {
        AppsFlyerLib.shared().start()
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window:
                     UIWindow?) -> UIInterfaceOrientationMask {
        if let window, let root = window.rootViewController,
           let navVC = root as? UINavigationController,
           let topVC = navVC.viewControllers.first,
           !topVC.isBeingPresented,
           !topVC.isBeingDismissed  {
            guard topVC is MainViewController || topVC is DetailsViewController else { return .all }
            return .portrait
        }
        return .portrait
    }
        
    // MARK: - SDK SETUP
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

           guard let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                 let annotation = options[UIApplication.OpenURLOptionsKey.annotation] else {
               return false
           }

           if TikTokOpenSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: annotation) {
               return true
           }
           return false
       }

       func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
           if TikTokOpenSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
               return true
           }
           return false
       }

       func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
           if TikTokOpenSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: nil, annotation: "") {
               return true
           }
           return false
       }

}

//MARK: TikTokOpenSDKLogDelegate
extension AppDelegate: TikTokOpenSDKLogDelegate {
    func onLog(_ logInfo: String) {
        print("TikTok LogInfo: ", logInfo)
    }
}


//MARK: AppsFlyerLibDelegate
extension AppDelegate: AppsFlyerLibDelegate {
    
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        for (key, value) in installData {
            print(key, ":", value)
        }
        if let status = installData["af_status"] as? String {
            UserDefaultsManager.shared[.organic] = status
            if (status == "Non-organic") {
                if let campaign = installData["campaign"] {
                    UserDefaultsManager.shared[.campaign] = campaign as? String
                }
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
    }
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
    }
}
