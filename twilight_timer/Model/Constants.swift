//
//  Constants.swift
//  twilight_timer
//
//  Created by Asiya on 5/1/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation

struct K {
    // Background Refresh
//    static let bgWeatherRefreshID = "com.justinmajetich.twilight-timer.fetchWeather"
    
    // API Strings
    static let bgURLSessionID = "backgroundURLSession"
    static let openWeatherAPIKey = "49da713de0a0f823e722de3e39d1ec63"
    static let openWeatherAPIURL = "https://api.openweathermap.org/data/2.5/onecall"
    static let openWeatherApiRequestExclusions = "current,minutely,hourly,alerts"
    
    // Persistence
    static let sunsetStorageFilename = "SunsetData.plist"
    static let locationStorageFilename = "LocationData.plist"
    
    // Notification Names
    static let didUpdateLocation = Notification.Name("didUpdateLocation")
    static let didUpdateSunset = Notification.Name("didUpdateSunset")
    static let twilightDidEnd = Notification.Name("twilightDidEnd")
    
    // Day/Time Constants
    static let dayDuration = 86400.0
    static let twilightDuration = 1800.0
    
    // Animation markers
    static let animationProgressEndFrame = 240.0
    static let animationTwilightLoopStart = 420.0
    static let animationTwilightLoopEnd = 960.0
    
    // Amination refresh interval
    static let animationRefreshInterval = 60.0
}
