//
//  SunsetData.swift
//  twilight_timer
//
//  Created by Asiya on 4/18/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation

struct SunsetData: Codable {
    
    let daily: Array<Daily>
    
}

struct Daily: Codable {
    
    let dt: Date
    let sunset: Date
    
}
