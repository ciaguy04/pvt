//
//  AppDelegate.swift
//  Psychomotor Vigilance Task
//
//  Created by Emily Anthony on 10/27/16.
//  Copyright © 2016 vu_sleep. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let defaults = UserDefaults.standard
        if defaults.integer(forKey: ContextKeys.pvt_index) == 0 {
            defaults.set(0, forKey: ContextKeys.pvt_index)
            defaults.synchronize()
        }

        if defaults.integer(forKey: ContextKeys.arm) == 0 {
            print("setting arm")
            defaults.set(1, forKey: ContextKeys.arm)
            defaults.synchronize()
        }
        
        if defaults.string(forKey: ContextKeys.REDCap_record) == nil {
            print("setting ContextKeys.REDCap_record")
            defaults.set("", forKey: ContextKeys.arm)
            defaults.synchronize()
        }
        
        if #available(iOS 10.0, *) {
            print("10.0")
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {
                (granted, error) in
                if !granted {
                    print("Permission denied.")
                } else {
                    print("Permission granted")
                }
            }
        } else {
            print("9.0")
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        FIRApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")
        connectToFCM()
    }
    
    func connectToFCM(){
        FIRMessaging.messaging().connect {
            (error) in
            if (error != nil) {
                print("Unable to connect to FCM: \(error)")
            } else {
                print("Connected to FCM")
            }
        }
    }
}

