//
//  AppDelegate.swift
//  GithubRepos
//
//  Created by Mostfa on 27/04/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var appCoordinator: ApplicationFlowCoordinator!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let window =  UIWindow(frame: UIScreen.main.bounds)
    self.appCoordinator = ApplicationFlowCoordinator(window: window, dependencyProvider: ApplicationComponentsFactory())

    self.appCoordinator.start()

    self.window = window
    self.window?.makeKeyAndVisible()

    return true
  }

}
