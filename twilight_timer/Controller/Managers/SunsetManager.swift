//
//  SunsetManager.swift
//  twilight_timer
//
//  Created by Asiya on 4/17/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import UIKit
import Foundation

class SunsetManager {
    
    var delegate: SunsetManagerDelegate?
    
    let storage = StorageManager()
    
    var currentSunset: SunsetModel?

    init() {
        // Initialize currentSunset from last stored model.
        // currentSunset will be nil if load fails
        self.loadSunsetFromDisk()
    }
}

//MARK: - Networking
    
extension SunsetManager {
    
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
                            let sunset = self.updateSunset(from: sunsetData)
                            self.delegate?.didUpdateSunset(manager: self, sunset)
                        }
                    }
                }
            }
            // Start session task
            task.resume()
        }
    }
    
    func updateSunset(from data: SunsetData) -> SunsetModel {

        // Instantiate sunset model with decoded data
        return SunsetModel(sunsetTime: data.sys.sunset,
                           latitude: data.coord.lat,
                           longitude: data.coord.lon,
                           placeName: data.name)
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
}

//MARK: - Persistence

extension SunsetManager {

    func loadSunsetFromDisk() {
        // load() will return lastest sunset model, or nil on failure
        currentSunset = storage.load(from: K.sunsetStorageFilename)
    }
    
    func saveSunsetToDisk() {
        storage.save(currentSunset, to: K.sunsetStorageFilename)
    }

}
