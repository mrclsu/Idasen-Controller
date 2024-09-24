//
//  ContentView.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/23/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var deskState: DeskControllerState
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Connected to desk: \(deskState.name ?? "")")
                .font(.headline)
            Text("Position: \(deskState.position ?? 0.0)cm")
                .font(.subheadline)
            
            Spacer()
            UpDownButton {
                deskState.deskController?.moveUp()
            } downAction: {
                deskState.deskController?.moveDown()
            }
            Spacer()
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
