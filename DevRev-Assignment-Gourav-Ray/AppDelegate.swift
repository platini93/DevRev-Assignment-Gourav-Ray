//
//  AppDelegate.swift
//  DevRev-assignment-Gourav_Ray
//
//  Created by Gourav Ray on 03/04/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator:Coordinator?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // AppCoordinator config
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController.init()
        appCoordinator = AppCoordinator(navControl: navigationController)
        appCoordinator?.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

