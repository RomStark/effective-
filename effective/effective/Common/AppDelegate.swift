//
//  AppDelegate.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navcontroller = UINavigationController()
        let vc =  TodoListAssembly.init(navigationController: navcontroller).assemble()
        
        navcontroller.pushViewController(vc, animated: true)
        
        window?.rootViewController = navcontroller
        window?.makeKeyAndVisible()
        return true
    }
}

