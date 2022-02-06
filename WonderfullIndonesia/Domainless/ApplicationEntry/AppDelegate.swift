//
//  AppDelegate.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import UIKit
import netfox
import Localize_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    NFX.sharedInstance().start()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let mainController = HomeTabBarViewController() as UIViewController
    window?.rootViewController = mainController
    window?.makeKeyAndVisible()
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // applicationWillResignActive
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // applicationDidEnterBackground
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // applicationWillEnterForeground
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // applicationDidBecomeActive
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // applicationWillTerminate
  }
}
