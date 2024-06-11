//
//  ContentView.swift
//  Parking
//
//  Created by Gabriel Xavier on 2024-06-11.
//

import SwiftUI
import CoreLocation
import UIKit

struct carPicker: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedIcon: String = "car13"
    @State private var angle: Angle = .zero
    @State private var isNavigating = false
    
    let icons = (1...16).map { "car\($0)" }

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    CircularIconPicker(icons: icons, selectedIcon: $selectedIcon, angle: $angle)
                        .frame(width: 300, height: 300)
                    
                    if let selectedIconImage = UIImage(named: selectedIcon) {
                        Image(uiImage: selectedIconImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .position(x: UIScreen.main.bounds.width / 2 - 30, y: UIScreen.main.bounds.height/3)
                            .animation(.easeInOut)
                    }
                }
                .padding()
                
                NavigationLink(destination: saveLocation(carIcon: selectedIcon), isActive: $isNavigating) {
                    Button(action: {
                        isNavigating = true
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
            .background(backgroudColor)
            .navigationTitle("Car Model")
        }
    }
    
    var backgroudColor: Color {
        switch colorScheme {
        case .light:
            return Color.yellow.opacity(0.15)
        case .dark:
            return Color(#colorLiteral(red: 0, green: 0, blue: 0.2470588235, alpha: 1))
        @unknown default:
            return Color.yellow.opacity(0.5)
        }
    }
}

#Preview {
    carPicker()
}
