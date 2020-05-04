//
//  StorageManager.swift
//  twilight_timer
//
//  Created by Asiya on 5/3/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation

struct StorageManager {
    
    let sunsetDataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("SunsetData.plist")
        
    // Save sunset model to app documents folder
    func saveSunset(_ sunset: SunsetModel) {
        
        print(sunsetDataPath!)
        
        let encoder = PropertyListEncoder()
        do {
            let sunsetData = try encoder.encode(sunset)
            try sunsetData.write(to: sunsetDataPath!)
            
        } catch {
            print("saveSunset: save failed: \(error)")
        }
        
    }
    
    // Load sunset model to app documets folder
    func loadSunset() -> SunsetModel? {
        
        do {
            let data = try Data(contentsOf: sunsetDataPath!)
            let decoder = PropertyListDecoder()
            let sunset = try decoder.decode(SunsetModel.self, from: data)
            return sunset
            
        } catch {
            print("loadSunset: load failed: \(error)")
            return nil
        }
        
    }
    
}
