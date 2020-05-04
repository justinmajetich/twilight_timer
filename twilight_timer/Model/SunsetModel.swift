//
//  SunsetModel.swift
//  twilight_timer
//
//  Created by Asiya on 4/18/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation

struct SunsetModel: Codable {
    
    var sunsetTime: Date
    var latitude: Double
    var longitude: Double
    var updatedAt: Date
    var placeName: String?

}

    
