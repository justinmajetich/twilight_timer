//
//  ViewController.swift
//  twilight_timer
//
//  Created by Asiya on 2/22/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
        
    
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startMonitoringSignificantLocationChanges()

        weatherManager.delegate = self
        print("View Loaded")
    }

}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            print("Authorized Always")
        } else {
            print("Not Authorized")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location Updated: \(locations)")
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.getWeather(lat: lat, lon: lon)
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
        dateFormatter.dateFormat = "MM/dd/yyyy, HH:mm:ss z"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let localTime = dateFormatter.string(from: sunset.sunsetTime)
        let locationName = sunset.placeName
        
        print("Today's sunset in \(locationName) is at \(localTime).")
        
        DispatchQueue.main.async {
            self.sunsetTimeLabel.text = "Today's Sunset: \(localTime)"
            self.currentLocationLabel.text = "Location: \(locationName)"
        }
    }
}
