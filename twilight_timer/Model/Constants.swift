//
//  Constants.swift
//  twilight_timer
//
//  Created by Asiya on 5/1/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation

struct K {
    static let bgWeatherRefreshID = "com.justinmajetich.twilight-timer.fetchWeather"
    static let bgURLSessionID = "backgroundURLSession"
    static let openWeatherAPIKey = "49da713de0a0f823e722de3e39d1ec63"
    static let openWeatherAPIURL = "https://api.openweathermap.org/data/2.5/weather"
    static let sunsetStorageFilename = "SunsetData.plist"
    static let locationStorageFilename = "LocationData.plist"
    static let didUpdateLocation = Notification.Name("didUpdateLocation")
}
