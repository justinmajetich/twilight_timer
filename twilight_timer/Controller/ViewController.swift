//
//  ViewController.swift
//  twilight_timer
//
//  Created by Asiya on 2/22/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController {
        
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    var notificationManager = NotificationManager()
    
//    var currentSunset: SusnetModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print("View Loaded")
    }

    @IBAction func setTestNotificationButton(_ sender: UIButton) {
        
        let testNotif = notificationManager.create("Test Alert", "This is a test of the notification system.")
        notificationManager.schedule(for: Date(timeIntervalSinceNow: 10), content: testNotif)
        
    }
}

