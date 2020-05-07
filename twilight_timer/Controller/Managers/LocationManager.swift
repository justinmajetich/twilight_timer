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
    lazy var storage = StorageManager()
    
    var currentLatitude: String?
    var currentLongitude: String?
    var updatedAt: Date?
    
    override init() {
        super.init()

        // Configure a CLLocationManager object
        cllManager.delegate = self
        cllManager.requestWhenInUseAuthorization()
        cllManager.allowsBackgroundLocationUpdates = true
        cllManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        cllManager.requestLocation()
    }
    
    func requestLocationUpdate() {
        cllManager.requestLocation()
    }
    
    // Load last recorded coordinates from disk
    private func loadLastCoordinatesFromDisk() {
        if let lastLocationData: LocationData = storage.load(from: K.locationStorageFilename) {
            currentLatitude = lastLocationData.latitude
            currentLongitude = lastLocationData.longitude
        }
    }
    
    // Save most recent coordinates to disk
    private func saveCurrentCoordinatesToDisk() {
        // If location data is currently maintained, save to disk
        if let safeLatitude = currentLatitude,
            let safeLongitude = currentLongitude {
            storage.save(LocationData(latitude: safeLatitude,
                                      longitude: safeLongitude),
                         to: K.locationStorageFilename)
        } else {
            print("No location data to save to disk")
        }
    }
}


//MARK: - CLLocationManagerDelegate Methods

extension LocationManager: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let safeLocation = locations.last{
            currentLatitude = String(safeLocation.coordinate.latitude)
            currentLongitude = String(safeLocation.coordinate.longitude)
            updatedAt = safeLocation.timestamp
            NotificationCenter.default.post(name: K.didUpdateLocation,
                                            object: self,
                                            userInfo: ["latitude": currentLatitude!,
                                                       "longitude": currentLongitude!])
        }
        
        
        
        print("Location Updated: \(locations)")

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("Location Services Authorized When In Use")
        } else {
            print("Location Services Not Authorized")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: \(error)")
    }
    
}
