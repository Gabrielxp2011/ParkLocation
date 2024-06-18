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
    @State private var carLocationExists = false
    @State private var savedCarIcon: String?
    @State private var referenceText: String?
    
    let icons = (1...16).map { "car\($0)" }

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                ZStack {
                    CircularIconPicker(icons: icons, selectedIcon: $selectedIcon, angle: $angle)
                        .frame(width: 300, height: 300)
                        .padding()
                    
                    if let selectedIconImage = UIImage(named: selectedIcon) {
                        Image(uiImage: selectedIconImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .animation(.easeInOut)
                    }
                }
                .frame(maxWidth: .infinity)                
                Spacer()
                
                if carLocationExists, let savedCarIcon = savedCarIcon, let savedCarImage = UIImage(named: savedCarIcon) {
                    Button(action: {
                        openMaps()
                    }) {
                        HStack {
                            Image(uiImage: savedCarImage)
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Go to my car")
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5)
                        .padding()
                        .contextMenu {
                            Button(action: {
                                if let referenceText = referenceText {
                                    showAlertPopup(message: referenceText)
                                }
                            }) {
                                Text(referenceText ?? "")
                                Image(systemName: "text.bubble")
                            }
                        }
                    }
                }
                
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
            .background(backgroundColor.ignoresSafeArea())
            .navigationTitle("Car Model")
            .onAppear(perform: checkCarLocation)
        }
    }
    
    //MARK: backgroundColor
    var backgroundColor: Color {
        switch colorScheme {
        case .light:
            return Color.yellow.opacity(0.15)
        case .dark:
            return Color(#colorLiteral(red: 0, green: 0, blue: 0.2470588235, alpha: 1))
        @unknown default:
            return Color.yellow.opacity(0.5)
        }
    }
    
    //MARK: showAlertPopup
    // Function to show a popup alert with the given message
    private func showAlertPopup(message: String) {
        let alert = UIAlertController(title: "Reference", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: checkCarLocation
    // Function to check if car location exists in UserDefaults
    private func checkCarLocation() {
        let latitude = UserDefaults.standard.double(forKey: "latitude")
        let longitude = UserDefaults.standard.double(forKey: "longitude")
        
        carLocationExists = (latitude != 0 && longitude != 0)
        
        if let savedReference = UserDefaults.standard.string(forKey: "referenceText") {
            referenceText = savedReference
        }
        
        if let savedIcon = UserDefaults.standard.string(forKey: "carModel") {
            savedCarIcon = savedIcon
        }
    }
    
    //MARK: openMaps
    // Function to open Apple Maps with saved location
    private func openMaps() {
        let latitude = UserDefaults.standard.double(forKey: "latitude")
        let longitude = UserDefaults.standard.double(forKey: "longitude")
        
        if latitude != 0 && longitude != 0 {
            let urlString = "http://maps.apple.com/?ll=\(latitude),\(longitude)&q=MyCar"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }
}

#Preview {
    carPicker()
}
