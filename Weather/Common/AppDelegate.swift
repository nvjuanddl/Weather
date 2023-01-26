//
//  AppDelegate.swift
//  Weather
//
//  Created by Juan Delgado Lasso on 25/01/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let wireframe = LocationWeatherFinderWireframe()
        let navigationController = UINavigationController(rootViewController: wireframe.viewController)
        navigationController.navigationBar.isHidden = false
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

