//
//  AppDelegate.swift
//  Todoey
//
//  Created by YU on 2018/11/26.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("didFinishLaunchingWithOptions")
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        //找到realm儲存的地方
        do {
            _ = try Realm()
        } catch {
            print(error)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
     
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
        print("applicationDidEnterBackground")
        //切換別App，App還在背景運作
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
     
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    
    
    
    
}

