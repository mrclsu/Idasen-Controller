//
//  IconButton.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/27/24.
//

import SwiftUI

struct ImageButton: View {
    let systemName: String
    let caption: String?
    let role: ButtonRole?
    let fullSize: Bool
    let action: () -> Void
   
    init(systemName: String, caption: String? = nil, role: ButtonRole? = nil, fullSize: Bool = false, action: @escaping () -> Void) {
        self.systemName = systemName
        self.caption = caption
        self.role = role
        self.action = action
        self.fullSize = fullSize
    }
    
    var body: some View {
        Button(role: role) {
            action()
        } label: {
            if let caption = caption {
                Label(caption, systemImage: systemName)
                    .if(fullSize) {
                        $0.frame(maxWidth: .infinity, minHeight: .infinity)
                    }
            } else {
                Image(systemName: systemName)
                    .padding()
            }
        }
    }
}

#Preview {
    ImageButton(systemName: "plus", caption: "Add") {
        
    }
}
