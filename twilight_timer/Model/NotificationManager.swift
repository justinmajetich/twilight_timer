//
//  NotificationManager.swift
//  twilight_timer
//
//  Created by Asiya on 4/22/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    let center = UNUserNotificationCenter.current()
    
    func authorizeNotifications() {
        
        center.getNotificationSettings { (settings) in
            
            // if authorization has not been determined, request
            if settings.authorizationStatus == .notDetermined {
                self.center.requestAuthorization(options: [.alert, .badge, .sound, .provisional]) { (authorized, error) in
                    if authorized == true {
                        print("Notifications Authorized")
                    } else {
                        print("Notification Autorization Error: \(String(describing: error))")
                    }
                }
            }
        }
    }
    
    func createNotification(_ identifier: String, _ title: String, _ body: String) -> UNMutableNotificationContent {
        
        let content = UNMutableNotificationContent()
        
        content.categoryIdentifier = identifier
        content.title = title
        content.body = body
        content.sound = .default
        
        return content
    }
    
    func scheduleNotification() {
        
    }
    
    func clearNotifications() {
        
    }
    
}
