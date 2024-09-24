//
//  RemoteScreen.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/24/24.
//

import SwiftUI

struct RemoteScreen: View {
    @EnvironmentObject var deskState: DeskControllerState
    
    var body: some View {
        NavigationView {
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
            .navigationTitle("Remote")
        }
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    RemoteScreen()
}
