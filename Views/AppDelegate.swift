//
//  AppDelegate.swift
//  tableView
//
//  Created by macbook on 21 Shevat 5779.
//  Copyright © 5779 macbook. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
        _ = try Realm()
        } catch {
            print ("Error loading Realm")
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }

}

