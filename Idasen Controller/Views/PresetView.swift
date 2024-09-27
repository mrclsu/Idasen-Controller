//
//  Presets.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/27/24.
//

import SwiftUI

struct PresetView: View {
    let preset: Preset
    @Binding var active: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(preset.name)
                    .font(.title3)
                Text("\(Int(preset.position.rounded()))cm")
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

#Preview(traits: .sizeThatFitsLayout, .fixedLayout(width: 110, height: 70)) {
    PresetView(preset: Preset(name: "Stand", position: 110), active: Binding.constant(true)) {
        
    }
}
#Preview(traits: .sizeThatFitsLayout, .fixedLayout(width: 110, height: 70)) {
    PresetView(preset: Preset(name: "Sit", position: 80), active: Binding.constant(false)) {
        
    }
}
