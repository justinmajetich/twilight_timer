//
//  WeatherData.swift
//  twilight_timer
//
//  Created by Asiya on 4/18/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let sys: Sys
    let name: String
}

struct Sys: Codable {
    let sunset: Date
    let sunrise: Date
}
