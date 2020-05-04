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
    
    func authorize() {
                
        let authorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        center.requestAuthorization(options: authorizationOptions) { (authorized, error) in
            
            if error == nil {
                if authorized == true {
                    print("Notifications Authorized")
                } else {
                    print("Notifications Not Authorized")
                }
            } else {
                print("Notification Autorization Error: \(String(describing: error))")
            }
        }
    }
    
    
    func create(title: String, body: String, _ userInfo: [String: Any]? = nil) -> UNMutableNotificationContent {
        
        let content = UNMutableNotificationContent()
        
        if userInfo != nil { content.userInfo = userInfo! }
        content.title = title
        content.body = body
        content.sound = .default
        
        return content
    }
    
    
    func schedule(for date: Date, content: UNMutableNotificationContent) {
        
        // Extract components from Date object using current calendar
        let components = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day,
                                                                      .hour, .minute, .second,
                                                                      .timeZone], from: date)
        print(components)
        
        // Create trigger from DateComponents object
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        // Create notification request from trigger and content
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        // Add request to notification center delivery schedule
        center.add(request) { (error) in
            if error != nil {
                print("Add Notification Error: \(String(describing: error))")
            } else {
                print("Notification Added")
            }
        }
    }
    
    func clear() {
        center.removeAllPendingNotificationRequests()
    }
    
}
