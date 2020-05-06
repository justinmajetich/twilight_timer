//
//  SunsetModel.swift
//  twilight_timer
//
//  Created by Asiya on 4/18/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation

class SunsetModel: Codable {
    
    var sunsetTime: Date
    var latitude: Double
    var longitude: Double
    var updatedAt: Date
    var placeName: String

    init(sunsetTime: Date, latitude: Double,
         longitude: Double, placeName: String? = "Unknown") {
        
        self.sunsetTime = sunsetTime
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = placeName!
        self.updatedAt = Date()
    }
    
}

    
