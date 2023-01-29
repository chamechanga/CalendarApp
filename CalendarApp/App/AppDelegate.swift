//
//  AppDelegate.swift
//  CalendarApp
//
//  Created by Charmaine Andrea Legaspi on 1/29/23.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private var appCoordinator: AppCoordinator!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Firebase Configuration for the login
    FirebaseApp.configure()
    
    let navigationController = UINavigationController()
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.shadowColor = nil

    let navigationBar = navigationController.navigationBar
    navigationBar.standardAppearance = appearance
    navigationBar.scrollEdgeAppearance = appearance
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    appCoordinator = AppCoordinator(navigationController: navigationController)
    appCoordinator.start()
    
    return true
  }
}

