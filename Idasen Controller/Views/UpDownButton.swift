//
//  UpDownButton.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/24/24.
//

import SwiftUI

private struct Btn: View {
    var action: () -> Void
    var systemName: String
    
    init(action: @escaping () -> Void, systemName: String) {
        self.action = action
        self.systemName = systemName
    }
    
    var body: some View {
        Button(action: self.action) {
            ZStack {
                Rectangle()
                    .fill(.gray)
                Image(systemName: systemName)
            }
        }
        .foregroundStyle(.black)
        .frame(width: 100, height: 100)
        .buttonRepeatBehavior(.enabled)
    }
}

struct UpDownButton: View {
    var upAction: () -> Void
    var downAction: () -> Void
    
    var body: some View {
        
        VStack(spacing: 0) {
            Btn(action: upAction, systemName: "chevron.up")
            Btn(action: downAction, systemName: "chevron.down")
        }
        .frame(width: 100, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 1000))
    }
}

#Preview {
    UpDownButton(upAction: {}, downAction: {})
}
