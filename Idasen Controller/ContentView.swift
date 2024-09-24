//
//  ContentView.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/23/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            RemoteScreen()
                .tabItem {
                    Label("Remote", systemImage: "av.remote")
                }
            PreferencesScreen()
                .tabItem {
                    Label("Preferences", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DeskControllerState())
}
