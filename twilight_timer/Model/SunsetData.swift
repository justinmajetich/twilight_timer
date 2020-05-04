//
//  SunsetData.swift
//  twilight_timer
//
//  Created by Asiya on 4/18/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation

struct SunsetData: Codable {
    let coord: Coord
    let sys: Sys
    let name: String
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Sys: Codable {
    let sunset: Date
    let sunrise: Date
}
