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
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    // Managers
    var userNotificationManager = UserNotificationManager()
    var sunsetManager = SunsetManager()

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sunsetManager.delegate = self
        
        print("View Did Load")
    }

    @IBAction func setTestNotificationButton(_ sender: UIButton) {
        
        let testNotif = userNotificationManager.create(title: "Test Alert",
                                                   body: "This is a test of the notification system.")
        userNotificationManager.schedule(for: Date(timeIntervalSinceNow: 10), content: testNotif)
        
    }
}

//MARK: - SunsetManagerDelegate

extension SunsetViewController: SunsetManagerDelegate {
    
    func didUpdateSunset(manager: SunsetManager, _ sunset: SunsetModel) {
        
        // format date with current timezone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss, MM/dd/yyyy z"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        sunsetTimeLabel.text = dateFormatter.string(from: sunset.sunsetTime)
        currentLocationLabel.text = sunset.placeName

        // Clear scheduled notification and set new
        userNotificationManager.clear()
        let testNotif = userNotificationManager.create(title: "Test Sunset Alert",
                                                   body: "This is a test of the sunset notification system.")
        userNotificationManager.schedule(for: sunset.sunsetTime, content: testNotif)
    }
    
    func didFailUpdateWithError(error: Error) {
        print("Sunset Update Failed: \(error)")
    }
    
}
