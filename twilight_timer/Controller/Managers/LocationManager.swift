//
//  LocationManager.swift
//  twilight_timer
//
//  Created by Asiya on 5/6/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    let cllManager = CLLocationManager()
    
    override init() {
        super.init()

        // Configure a CLLocationManager object
        cllManager.delegate = self
        cllManager.requestWhenInUseAuthorization()
        cllManager.allowsBackgroundLocationUpdates = true
        cllManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
}

//MARK: - CLLocationManagerDelegate Methods

extension LocationManager: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Location Updated: \(locations)")
        
        if let safeLocation = locations.last{
            let latitude = String(safeLocation.coordinate.latitude)
            let longitude = String(safeLocation.coordinate.longitude)
//            sunsetManager.fetchSunsetData(lat: latitude, lon: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("Location Services Authorized When In Use")
        } else {
            print("Location Services Not Authorized")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: \(error)")
    }
    
}
