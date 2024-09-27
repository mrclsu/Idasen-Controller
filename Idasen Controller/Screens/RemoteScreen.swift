//
//  RemoteScreen.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/24/24.
//

import SwiftUI

struct RemoteScreen: View {
    @EnvironmentObject var deskState: DeskControllerState
    
    @State var presets: [Preset] = UserDefaults.loadArrayFromStandard(forKey: "presets", type: [Preset].self)
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Connected to desk: \(deskState.name ?? "")")
                    .font(.headline)
                Text("Position: \(Int(deskState.position?.rounded() ?? 0.0))cm")
                    .font(.subheadline)
                
                Spacer()
                UpDownButton {
                    deskState.deskController?.moveUp()
                } downAction: {
                    deskState.deskController?.moveDown()
                }
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Presets")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(presets.enumerated()), id: \.offset) { index, preset in
                                PresetView(preset: preset, active: Binding.constant(false)) {
                                    deskState.deskController?.moveToHeight(preset.position)
                                }
                                    .frame(width: 90, height: 60)
                                    .contextMenu() {
                                        ImageButton(systemName: "trash", caption: "Delete", role: .destructive) {
                                            presets.remove(at: index)
                                            UserDefaults.saveArrayToStandard(presets, forKey: "presets")
                                        }
                                    }
                                
                            }
                            
                            ImageButton(systemName: "plus", fullSize: true) {
                                withAnimation {
                                    presets.append(Preset(name: "M\(presets.count)", position: deskState.position ?? 0.0))
                                    UserDefaults.saveArrayToStandard(presets, forKey: "presets")
                                }
                            }
                            
                            .frame(width: 90, height: 60)
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Remote")
        }
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    RemoteScreen()
        .environmentObject(DeskControllerState())
}
