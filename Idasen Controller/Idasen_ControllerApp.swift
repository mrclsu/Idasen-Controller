//
//  Idasen_ControllerApp.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/23/24.
//

import SwiftUI

@main
struct Idasen_ControllerApp: App {
    @StateObject var deskState = DeskControllerState()
    
    init() {
        BluetoothManager.shared.startScanning()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(deskState)
        }
    }
}
