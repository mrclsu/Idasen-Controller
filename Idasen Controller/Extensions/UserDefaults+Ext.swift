//
//  UserDefaults+Ext.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/27/24.
//

import SwiftUI
import Foundation

extension UserDefaults {
    static func saveArrayToStandard<T>(_ arr: [T], forKey key: String) where T: Encodable {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(arr) {
            UserDefaults.standard.set(data, forKey: key)
            print("Saved")
        } else {
            print("Error")
        }
        
    }
    
    static func loadArrayFromStandard<T>(forKey key: String, type: [T].Type) -> [T] where T: Decodable  {
        let decoder = JSONDecoder()
        
        if let json = UserDefaults.standard.data(forKey: key),
           let data = try? decoder.decode(type, from: json) {
            return data;
        }
        
        
        
        return []
    }
}
