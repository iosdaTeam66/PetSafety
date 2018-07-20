//
//  AppDelegate.swift
//  PetSafety
//
//  Created by De Cristofaro Paolo on 10/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // mette a zero le notifiche quando apri la notifica
        UIApplication.shared.applicationIconBadgeNumber = 0
        let operation = CKModifyBadgeOperation(badgeValue: 0)
        operation.modifyBadgeCompletionBlock = {(error) in
            if let error = error{
                print("ERRORE AZZERAMENTO NOTIFICHE: \(error)")
                return
            }
            
        }
        CKContainer.default().add(operation)
        
        //ask the user for permission to show notifications
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate;
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { authorized, error in
            if authorized {
                //risolto warning
                
                DispatchQueue.main.async(execute: {
                    application.applicationIconBadgeNumber = 0
                    application.registerForRemoteNotifications()
                })
            }
        })
        
        
        return true
    }
    
    //subscription
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        //prende cani da core data
        var cani: [PPet] = PersistenceManager.fetchData()
        
        for i in 0..<cani.count {
            print("CANE: \(String(describing: cani[i].name))")
        }
        
        for i in 0..<cani.count  {
            
            
            //notification on new record of coordinate
            let subscription = CKQuerySubscription(recordType: "Coordinate", predicate: NSPredicate(format: "%K == %@",argumentArray: ["beaconID","36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:\(cani[i].beaconid!)"]), options: .firesOnRecordCreation)
            
            print("subscription: \(subscription.predicate)")
            
            let info = CKNotificationInfo()
            info.alertBody = ("\(cani[i].name!) has been localized")
            info.shouldBadge = true
            info.soundName = "default"
            subscription.notificationInfo = info
            
            CKContainer.default().publicCloudDatabase.save(subscription, completionHandler: { subscription, error in
                if error != nil {
                    print("Notifica: Error")
                }
            })
        }
        
        
        print("FINE!!!!")
    }
    
    
    
    
    //UserNotifications framework to show your notification as if your app wasn't running at all
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound,.badge])
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.shared.applicationIconBadgeNumber = 0
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PetSafety")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
