//
//  SunsetManager.swift
//  twilight_timer
//
//  Created by Asiya on 4/17/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation

class SunsetManager {
        
    let locationManager = LocationManager()
    let storage = StorageManager()
    
    var sunset: SunsetModel?
    
    init() {
       
        loadSunsetFromDisk()
        
        // Initialize observer to monitor notification of location update
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didUpdateLocations),
            name: K.didUpdateLocation,
            object: locationManager
        )
                
        locationManager.requestLocationUpdate()
    }
        
    // This function is called whenever the sunset model is updated in order to handle follow up behavior
    private func didUpdateSunset() {
        
        // Once today's twilight has ended, update sunset to reflect next sunset.
        DispatchQueue.main.asyncAfter(deadline: .now() + (sunset!.nextSunset.timeIntervalSinceNow + K.twilightDuration)) {
            
            self.fetchSunsetData(
                lat: self.locationManager.currentLatitude ?? "",
                lon: self.locationManager.currentLongitude ?? ""
            )
        }
        
        NotificationCenter.default.post(
            name: K.didUpdateSunset,
            object: self,
            userInfo: ["nextSunset": sunset!.nextSunset]
        )
    }
}

//MARK: - Networking
    
private extension SunsetManager {
    
    func fetchSunsetData(lat: String, lon: String) {
        
        let apiKey = K.openWeatherAPIKey
        let apiURL = K.openWeatherAPIURL
        let exclude = K.openWeatherApiRequestExclusions
       
        if let url = URL(string: "\(apiURL)?lat=\(lat)&lon=\(lon)&exclude=\(exclude)&appid=\(apiKey)") {
            
            let session = URLSession(configuration: .default)
            
            // Define session task with completetion handler
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                } else {
                    if let safeData = data {
                        // Parse JSON data package
                        if let sunsetData = self.parseJSON(data: safeData) {
                            self.updateSunsetWithData(in: sunsetData)
                            self.saveSunsetToDisk()
                        }
                    }
                }
            }
            // Start session task
            task.resume()
        }
    }
    
    private func updateSunsetWithData(in sunsetData: SunsetData) {
        
        // If now is before the end of today's twilight, use today's twilight for current model
        if Date() < sunsetData.daily[0].sunset.addingTimeInterval(K.twilightDuration) {
            sunset = SunsetModel(
                nextSunset: sunsetData.daily[0].sunset
            )
        // Otherwise, assign following sunset to current.
        } else {
            sunset = SunsetModel(
                nextSunset: sunsetData.daily[1].sunset
            )
        }
        
        didUpdateSunset()
    }
    
    // Decode JSON response from the OpenWeatherMap API
    func parseJSON(data: Data) -> SunsetData? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        do {
            let weatherData = try decoder.decode(SunsetData.self, from: data)
            return weatherData
        } catch {
            return nil
        }
    }
}

//MARK: - Notification Observance

private extension SunsetManager {
       
    // Triggers when CLLocationManagerDelegate method didUpdateLocations is called
    // and location manager has successfully updated coordinates
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
        if let loadedSunset: SunsetModel = storage.load(from: K.sunsetStorageFilename) {
            
            sunset = loadedSunset
            
            didUpdateSunset()
        }
    }
    
    func saveSunsetToDisk() {
        storage.save(sunset, to: K.sunsetStorageFilename)
    }

}
