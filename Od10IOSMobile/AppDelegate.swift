//
//  AppDelegate.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 11/26/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor(named: "odoo_purple")
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        // ログイン判定
        let ud = UserDefaults.standard
        let isLogin: Bool? = ud.object(forKey: "isLogin") as? Bool

        // 未ログインの場合
        if isLogin != nil && isLogin! {
            let viewController: LoginViewController = LoginViewController()
            navigationController = UINavigationController(rootViewController: viewController)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        // ログイン中の場合
        } else {
            let viewController: MainMenuViewController = MainMenuViewController()
            navigationController = UINavigationController(rootViewController: viewController)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        
//        let userLoginStatus = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
//
//            if(userLoginStatus)
//            {
//                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let centerVC = mainStoryBoard.instantiateViewController(withIdentifier: "navigationTabVC") as! navigationTabVC
//                window!.rootViewController = centerVC
//                window!.makeKeyAndVisible()
//            }
        
//        Switcher.updateRootVC()
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
 
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        Switcher.updateRootVC()
//        return true
//    }

}

