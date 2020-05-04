//
//  StorageManager.swift
//  twilight_timer
//
//  Created by Asiya on 5/3/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import Foundation

struct StorageManager {
    
    let dirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
    // Save Encodable-compliant instance to documents folder
    func save<encodableType: Encodable>(_ instance: encodableType, to filename: String) {
        
        let path = dirPath?.appendingPathComponent(filename)
        print(path!)
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(instance)
            try data.write(to: path!)
        } catch {
            print("save: failed to save \(filename): \(error)")
        }
        
    }
    
    // Load Decodable-compliant instance from documets folder
    func load<decodableType: Decodable>(from filename: String) -> decodableType? {
        
        let path = dirPath?.appendingPathComponent(filename)
        
        do {
            let data = try Data(contentsOf: path!)
            let decoder = PropertyListDecoder()
            let instance = try decoder.decode(decodableType.self, from: data)
            return instance
        } catch {
            print("load: failed to load \(filename): \(error)")
            return nil
        }
        
    }
    
}
