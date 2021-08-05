//
//  SunsetViewController.swift
//  twilight_timer
//
//  Created by Asiya on 2/22/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class SunsetViewController: UIViewController {
    
    // Storyboard Elements
    @IBOutlet weak var animationWrapper: UIView!
    
    // Managers
    var userNotificationManager = UserNotificationManager()
    var sunsetManager: SunsetManager?
    var animationManager: AnimationManager?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize sunsetManager and subscribe to sunset update events.
        sunsetManager = SunsetManager()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didUpdateSunset),
            name: K.didUpdateSunset,
            object: sunsetManager
        )
        
        // Initialize Animation Manager.
        animationManager = AnimationManager(wrapper: animationWrapper)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(sunsetManager!)
    }
}

//MARK: - Notification Observance

extension SunsetViewController {
    
    @objc func didUpdateSunset(_ notification: Notification) {
        
        if let data = notification.userInfo as? [String: Date] {
                    
            updateUserNotifications(data["nextSunset"]!)
            
            //            // Format date with current timezone
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "HH:mm:ss, MM/dd/yyyy z"
            //            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            //
            //            // Set label with formatted Date
            //            DispatchQueue.main.async {
            //                self.sunsetTimeLabel.text = dateFormatter.string(from: updatedSunset)
            //            }
        }
    }
    
    private func updateUserNotifications(_ sunsetTime: Date) {
        
        // Clear scheduled notifications and create updated notification.
        userNotificationManager.clear()
        
        let twilightNotif = userNotificationManager.create(
            title: "Twilight Alert",
            body: "Twilight has begun. Take a moment. Reflect."
        )
        
        userNotificationManager.schedule(for: sunsetTime, content: twilightNotif)
        
    }
}
