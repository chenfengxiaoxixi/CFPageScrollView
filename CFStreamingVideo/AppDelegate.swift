//
//  AppDelegate.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/8/19.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var isForceLandscapeRight: Bool = false
    var isForcePortrait: Bool = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        configData()
        
        let tabbar = CFTabBarController()
        self.window?.rootViewController = tabbar
        
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        //开启音视频会话
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setMode(.moviePlayback)
        
        return true
    }

    func configData() {
        
        if (UserDefaults.standard.value(forKey: "firstEnterApp") == nil) {
            
            UserDefaults.standard.set("1", forKey: "firstEnterApp")
            
            let dataSource: Array<Dictionary>! = getDataSource()
            
            for dic in dataSource {
                //MenuData这张表存放菜单数据
                let model: MenuData = CoreDataManager.getEntityAndInsertNewObjectWith(entityName: "MenuData") as! MenuData

                model.title = dic["title"] as? String
                model.controller = dic["controller"] as? String
                model.isNeedToDisplay = dic["isNeedToDisplay"] as! Bool == true ? true : false
                model.isAllowedEditing = dic["isAllowedEditing"] as! Bool == true ? true : false

                CoreDataManager.saveContext()
            }
            
            let displayData: Array<Dictionary>! = getDisplayDataSource()
            
            for dic in displayData {
                //MenuData这张表存放显示页面数据
                let model: DisplayData = CoreDataManager.getEntityAndInsertNewObjectWith(entityName: "DisplayData") as! DisplayData

                model.title = dic["title"] as? String
                model.controller = dic["controller"] as? String
                model.isNeedToDisplay = dic["isNeedToDisplay"] as! Bool == true ? true : false
                model.isAllowedEditing = dic["isAllowedEditing"] as! Bool == true ? true : false

                CoreDataManager.saveContext()
            }
            
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if isForcePortrait == true {
            return .portrait
        } else if isForceLandscapeRight == true {
            return .landscapeRight
        }
        
        return .portrait
        
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DataModel")
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

