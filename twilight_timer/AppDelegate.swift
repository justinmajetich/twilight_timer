//
//  AppDelegate.swift
//  twilight_timer
//
//  Created by Asiya on 2/22/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Initialize managers
    var userNotificationManager = UserNotificationManager()
    var storageManager = StorageManager()
            
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Register background weather fetch
        BGTaskScheduler.shared.register(forTaskWithIdentifier: K.bgWeatherRefreshID, using: nil) { task in
            self.manageBackgroundWeatherRefresh(task as! BGAppRefreshTask)
        }
        
        // Authorize local notifications
        userNotificationManager.authorize()
        
        print("Did Finish Launching With Options")
        
        return true
    }


    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    //MARK: - BackgroundTasks
      
    func manageBackgroundWeatherRefresh(_ task: BGAppRefreshTask) {
          
        let queue = OperationQueue()
        
        let operation = BackgroundSunsetRefresh()
        
        // Clean-up if task expires
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        // Inform system that task is complete when operation completes successfully
        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
        }
        
        // Start operation
        queue.addOperation(operation)
    }
    
    func scheduleBackgroundRefresh() {
        
    }
}
