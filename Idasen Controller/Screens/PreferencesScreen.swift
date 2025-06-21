//
//  PreferencesScreen.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/24/24.
//

import SwiftUI

struct PreferencesScreen: View {
    @State var currentDeskHeightRatio: Float = 0.5
    var body: some View {
        NavigationView {
            VStack {
                DeskVisualizerView(deskHeightRatio: $currentDeskHeightRatio)
                    
                Slider(value: $currentDeskHeightRatio, in: 0.0...1.0) {
                    Text("Desk Height")
                } minimumValueLabel: {
                    Text("Min")
                } maximumValueLabel: {
                    Text("Max")
                }
                .padding()
            }
            .navigationTitle("Preferences")
        }
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    PreferencesScreen()
}
