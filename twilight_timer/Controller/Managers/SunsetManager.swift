//
//  SunsetManager.swift
//  twilight_timer
//
//  Created by Asiya on 4/17/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class SunsetManager {
        
    let locationManager = LocationManager()
    let storage = StorageManager()
    
    var delegate: SunsetManagerDelegate?
    var currentSunset: SunsetModel?

    init() {
        // Initialize currentSunset from last stored model.
        // currentSunset will be nil if load fails
        loadSunsetFromDisk()
        addLocationUpdateObserver()
    }
    
    // Method triggers location update. Delegate method
    // didUpdateSunset will be called indirectly on success
    func updateSunset() {
        self.locationManager.requestLocationUpdate()
    }
}

//MARK: - Networking
    
private extension SunsetManager {
    
    func fetchSunsetData(lat: String, lon: String) {
        
        let apiKey = K.openWeatherAPIKey
        let apiURL = K.openWeatherAPIURL
       
        if let url = URL(string: "\(apiURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") {
            
            // Check app state to determine URLSession configuration
            var sessionConfig: URLSessionConfiguration {
                if UIApplication.shared.applicationState == .background {
                    return URLSessionConfiguration.background(withIdentifier: K.bgURLSessionID)
                } else {
                    return URLSessionConfiguration.default
                }
            }
            
            // Background config allows location updates while app not running
            let session = URLSession(configuration: sessionConfig)
            
            // Define session task with completetion handler
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailUpdateWithError(error: error!)
                    return
                } else {
                    if let safeData = data {
                        // Parse JSON data package
                        if let sunsetData = self.parseJSON(data: safeData) {
                            self.updateCurrentSunsetWithData(in: sunsetData)
                            self.delegate?.didUpdateSunset(manager: self, self.currentSunset!)
                            self.saveSunsetToDisk()
                        }
                    }
                }
            }
            // Start session task
            task.resume()
        }
    }
    
    func parseJSON(data: Data) -> SunsetData? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        // Decode JSON
        do {
            let weatherData = try decoder.decode(SunsetData.self, from: data)
            return weatherData
        } catch {
            self.delegate?.didFailUpdateWithError(error: error)
            return nil
        }
    }
    
    func updateCurrentSunsetWithData(in data: SunsetData) {

        // If model is already present, update.
        // Otherwise, initialize new model
        if currentSunset != nil {
            currentSunset?.sunsetTime = data.sys.sunset
            currentSunset?.latitude = data.coord.lat
            currentSunset?.longitude = data.coord.lon
            currentSunset?.placeName = data.name
        } else {
            currentSunset = SunsetModel(sunsetTime: data.sys.sunset,
                                        latitude: data.coord.lat,
                                        longitude: data.coord.lon,
                                        placeName: data.name)
        }
    }
    
    
}

//MARK: - Notification Observance

private extension SunsetManager {
    
    // Creates notification observer to monitor location updates
    func addLocationUpdateObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdateLocations),
                                               name: K.didUpdateLocation,
                                               object: locationManager)
    }
    
    // Triggers when CLLocationManagerDelegate method
    // didUpdateLocations is called and location manager
    // has successfully updated coordinates
    @objc func didUpdateLocations(_ notification: Notification) {
        
        if let updatedCoordinates = notification.userInfo as? [String: String] {
            fetchSunsetData(lat: updatedCoordinates["latitude"]!,
                            lon: updatedCoordinates["longitude"]!)
        }
    }
    
}


//MARK: - Persistence

extension SunsetManager {

    func loadSunsetFromDisk() {
        // load() will return lastest sunset model, or nil on failure
        currentSunset = storage.load(from: K.sunsetStorageFilename)
        self.delegate?.didUpdateSunset(manager: self, self.currentSunset!)
    }
    
    func saveSunsetToDisk() {
        storage.save(currentSunset, to: K.sunsetStorageFilename)
    }

}
