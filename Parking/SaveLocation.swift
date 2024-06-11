//
//  SaveLocation.swift
//  Parking
//
//  Created by Gabriel Xavier on 2024-06-11.
//

import UIKit
import SwiftUI
import CoreLocation

struct saveLocation: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var locationManager = LocationManager()
    @State private var carLocation: CLLocation?
    var carIcon: String

    var body: some View {
        NavigationView {
            VStack {
                if let carImage = UIImage(named: carIcon) {
                    Image(uiImage: carImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding()
                }
                
                Spacer()
                
                // TableView
                if let userLocation = locationManager.userLocation {
                    List {
                        Text("Latitude: \(userLocation.coordinate.latitude)")
                        Text("Longitude: \(userLocation.coordinate.longitude)")
                    }
                    .listStyle(.insetGrouped)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .scrollDisabled(true)
                }
                
                Button(action: {
                    handleButtonAction()
                }) {
                    Text(carLocation != nil ? "Open Maps" : "Save car location")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .navigationTitle("Save Car Location")
            .padding()
            .background(backgroundColor.ignoresSafeArea())
        }
    }
    
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
    
    private func handleButtonAction() {
        if carLocation != nil {
            openMaps()
        } else {
            saveCarLocation()
        }
    }
    
    private func saveCarLocation() {
        if let location = locationManager.userLocation {
            carLocation = location
        }
    }
    
    private func openMaps() {
        if let carLocation = carLocation {
            let coordinate = carLocation.coordinate
            let urlString = "http://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)&q=MyCar"
            print("urlString: \(urlString)")
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }
}


#Preview {
    saveLocation(carIcon: "car1")
}

