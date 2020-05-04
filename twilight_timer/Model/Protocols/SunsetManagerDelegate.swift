//
//  SunsetManagerDelegate.swift
//  twilight_timer
//
//  Created by Asiya on 4/19/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation

protocol SunsetManagerDelegate {
    func didUpdateSunset(manager: SunsetManager, _ sunset: SunsetModel)
    func didFailUpdateWithError(error: Error)
}
