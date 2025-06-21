//
//  DeskVisualizerView.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 6/21/25.
//

import SwiftUI
import RealityKit
import Combine

struct DeskVisualizerView: View {
    @State private var deskScene: Entity?
    @State private var legMiddleEntity: Entity?
    @State private var legTopEntity: Entity?
    
    let legMiddleMaxExtension: Float = 0.30
    let legTopMaxExtension: Float = 0.35
    
    @State private var initialLegMiddleY: Float = 0.0
    @State private var initialLegTopY: Float = 0.0
    
    @Binding var deskHeightRatio: Float
    
    
    var body: some View {
            RealityView { content in
                let anchorEntity = AnchorEntity(world: [0, 0, 0])
                let camera = PerspectiveCamera()
                
                if let loadedScene = try? await Entity(named: "Idasen") {
                    self.deskScene = loadedScene
                    content.add(loadedScene)
                    loadedScene.position = [0, -0.05, 0]
                    
                    camera.look(at: [0, 1, 0], from: [1, 1.5, 2], relativeTo: nil)
                    
                    // Find the movable entities
                    if let legMiddle = loadedScene.findEntity(named: "Idasen_Leg_Middle") {
                        self.legMiddleEntity = legMiddle
                        self.initialLegMiddleY = legMiddle.position.z // Store initial Y
                    } else { print("Error: Leg Middle entity not found!") }
                    
                    if let legTop = loadedScene.findEntity(named: "Idasen_Leg_Top") {
                        self.legTopEntity = legTop
                        self.initialLegTopY = legTop.position.z // Store initial Y
                    } else { print("Error: Leg Top entity not found!") }
                } else {
                    print("Error: Could not load AdjustableDeskTelescoping.usdz")
                }
                
                // Add lighting
                let ambientLight = PointLight()
                ambientLight.light.color = .white
                ambientLight.light.intensity = 1000
                ambientLight.position = [0, 0.5, 0.5]
                content.add(ambientLight)
                
                anchorEntity.addChild(camera)
                content.add(anchorEntity)
            }
            .frame(width: 200, height: 400)
            .onChange(of: deskHeightRatio, initial: false) { oldRatio, ratio  in
                withAnimation(.easeInOut(duration: 0.2)) {
                    // Calculate total desired extension based on ratio
                    let desiredExtension = ratio * (legMiddleMaxExtension + legTopMaxExtension)
                    
                    // Determine how much each leg segment should extend
                    var middleLegCurrentOffset: Float = 0.0
                    var topLegCurrentOffset: Float = 0.0
                    
                    if desiredExtension <= legMiddleMaxExtension {
                        // Only Leg Middle is extending
                        middleLegCurrentOffset = desiredExtension
                    } else {
                        // Leg Middle is fully extended, now Leg Top starts extending
                        middleLegCurrentOffset = legMiddleMaxExtension
                        topLegCurrentOffset = desiredExtension - legMiddleMaxExtension
                    }
                    
                    // Apply transforms
                    if let legMiddle = legMiddleEntity {
                        var transform = legMiddle.transform
                        transform.translation.z = initialLegMiddleY + middleLegCurrentOffset
                        legMiddle.move(to: transform, relativeTo: legMiddle.parent, duration: 0.1, timingFunction: .easeInOut)
                    }
                    
                    if let legTop = legTopEntity {
                        var transform = legTop.transform
                        transform.translation.z = initialLegTopY + topLegCurrentOffset
                        legTop.move(to: transform, relativeTo: legTop.parent, duration: 0.1, timingFunction: .easeInOut)
                    }
                }
            }
    }
}

#Preview {
    DeskVisualizerView(deskHeightRatio: .constant(0.5))
}
