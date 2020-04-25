//
//  WeatherManager.swift
//  twilight_timer
//
//  Created by Asiya on 4/17/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    func getSunset(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        // OpenWeatherMap API key
        let apiKey = "49da713de0a0f823e722de3e39d1ec63"
       
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") {
            
            // Check app state to determine URLSession configuration
            var sessionConfig: URLSessionConfiguration {
                if UIApplication.shared.applicationState == .background {
                    return URLSessionConfiguration.background(withIdentifier: "Background Location Request")
                } else {
                    return URLSessionConfiguration.default
                }
            }
            
            // Background config allows location updates while app not running
            let session = URLSession(configuration: sessionConfig)
            
            // Define session task with completetion handler
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                } else {
                    if let safeData = data {
                        // parse JSON data package
                        if let sunset = self.parseJSON(data: safeData) {
                            self.delegate?.didUpdateSunsetTime(manager: self, sunset)
                        }
                    }
                }
            }
            // Start session task
            task.resume()
        }
    }
    
    func parseJSON(data: Data) -> SunsetModel? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        // Decode JSON
        do {
            let decoded = try decoder.decode(WeatherData.self, from: data)
            
            // Instantiate sunset model with decoded data
            return SunsetModel(sunsetTime: decoded.sys.sunset,
                               sunriseTime: decoded.sys.sunrise,
                               placeName: decoded.name)
            
        } catch {
            print("Error: ParseJSON: \(error)")
            return nil
        }
    }
}
