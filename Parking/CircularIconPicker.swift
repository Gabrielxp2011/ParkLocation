//
//  CircularIconPicker.swift
//  Parking
//
//  Created by Gabriel Xavier on 2024-06-11.
//

import UIKit
import SwiftUI


struct CircularIconPicker: View {
    let icons: [String]
    @Binding var selectedIcon: String
    @Binding var angle: Angle
    @GestureState private var dragAngle: Angle = .zero
    
    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                ForEach(icons.indices, id: \.self) { index in
                    let icon = icons[index]
                    let iconAngle = angleForIndex(index, total: icons.count)
                    let adjustedAngle = iconAngle + angle + dragAngle
                    let x = center.x + cos(adjustedAngle.radians) * radius
                    let y = center.y + sin(adjustedAngle.radians) * radius
                    
                    Image(icon)
                        .resizable()
                        .frame(width: selectedIcon == icon ? 60 : 40, height: selectedIcon == icon ? 60 : 40)
                        .position(x: x, y: y)
                        .onTapGesture {
                            withAnimation {
                                selectedIcon = icon
                            }
                        }
                        .overlay(
                            Circle()
                                .stroke(selectedIcon == icon ? Color.blue : Color.clear, lineWidth: 0)
                                .frame(width: selectedIcon == icon ? 70 : 50, height: selectedIcon == icon ? 70 : 50)
                                .position(x: x, y: y)
                        )
                }
                // Marker for the top position
                Circle()
                    .fill(Color.clear)
                    .frame(width: 10, height: 10)
                    .position(x: center.x, y: center.y - radius)
            }
        }
    }
    
    private func angleForIndex(_ index: Int, total: Int) -> Angle {
        let fraction = Double(index) / Double(total)
        return .degrees(fraction * 360)
    }
}

#Preview {
    carPicker()
}

