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
    
    var locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var notificationManager = NotificationManager()
    
//    var currentSunset: SusnetModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      notificationManager.authorizeNotifications()
        
        // Setup location manager and authorize
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startMonitoringSignificantLocationChanges()
        
        weatherManager.delegate = self
        
       
        
        print("View Loaded")
    }

    @IBAction func setTestNotificationButton(_ sender: UIButton) {
        
        let testNotif = notificationManager.create("Test Alert", "This is a test of the notification system.")
               
        notificationManager.schedule(for: Date(timeIntervalSinceNow: 10), content: testNotif)
        
    }
    
    @IBAction func setTestSunsetNotificationButton(_ sender: UIButton) {
                
    }
    
    
}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            print("Location Services Authorized Always")
        } else {
            print("Location Services Not Authorized")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location Updated: \(locations)")
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.getSunset(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location retrieval failed: \(error)")
    }
    
}

//MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    
    func didUpdateSunsetTime(manager: WeatherManager, _ sunset: SunsetModel) {
       
        // format date with current timezone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss, MM/dd/yyyy z"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let localTime = dateFormatter.string(from: sunset.sunsetTime)
        let locationName = sunset.placeName
        
        print("Today's sunset in \(locationName) is at \(localTime).")
        
//        let testNotif = notificationManager.create("Test Sunset Alert", "This is a test of the sunset notification system.")
//        notificationManager.schedule(for: sunset.sunsetTime, content: testNotif)
        
        DispatchQueue.main.async {
            self.sunsetTimeLabel.text = "Today's Sunset: \(localTime)"
            self.currentLocationLabel.text = "Location: \(locationName)"
        }
    }
}
