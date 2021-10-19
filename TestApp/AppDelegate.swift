//
//  AppDelegate.swift
//  TestApp
//
//  Created by Andrew on 19.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?
    var navigationController = UINavigationController()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = ViewController()
        navigationController.viewControllers = [vc]
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

