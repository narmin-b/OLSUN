//
//  AppDelegate.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ app: UIApplication, open url: URL,
              options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      var handled: Bool

        let config = GIDConfiguration(clientID: "207601672687-h1t25jp8d3lrc1oio27pmd8gr82qjjpf.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = config
      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      return false
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if UserDefaultsHelper.getString(key: .appLanguage) == nil {
            LocalizationManager.shared.setLanguage("az")
        } else {
            _ = LocalizationManager.shared // triggers init and loads saved language
        }

        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

