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
        
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    var notificationManager = UserNotificationManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View Did Load")
    }

    @IBAction func setTestNotificationButton(_ sender: UIButton) {
        
        let testNotif = notificationManager.create(title: "Test Alert",
                                                   body: "This is a test of the notification system.")
        notificationManager.schedule(for: Date(timeIntervalSinceNow: 10), content: testNotif)
        
    }
}

