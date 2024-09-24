//
//  Position.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/23/24.
//

import Foundation

enum Position {
    case sit, stand, custom(height: Float)
}

class Preferences: NSObject {
    public static let shared = Preferences()
    let sittingPosition: Float = 80
    let standingPosition: Float = 100
   
    func forPosition(_ position: Position) -> Float {
        switch position {
        case .sit:
            return sittingPosition
        case .stand:
            return standingPosition
        case .custom(let height):
            return height
        }
    }
}
