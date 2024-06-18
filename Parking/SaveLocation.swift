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
    @Environment(\.colorScheme) var switchColors
    @StateObject private var locationManager = LocationManager()
    @State private var carLocation: CLLocation?
    @State private var showAlert = false
    @State private var referenceText: String = ""
    @State private var offset: CGFloat = 0
    var carIcon: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if let carImage = UIImage(named: carIcon) {
                        Image(uiImage: carImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .padding()
                    }
                    
                    Spacer()
                    
                    if let userLocation = locationManager.userLocation {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Reference:")
                                TextField("Enter reference", text: $referenceText)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .background(Color.clear)
                            }
                            Text("Latitude: \(userLocation.coordinate.latitude)")
                            Text("Longitude: \(userLocation.coordinate.longitude)")
                        }
                        .padding()
                        .background(colorsList)
                        .cornerRadius(10)
                        .padding()
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
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Location Already Saved"),
                            message: Text("You already have a saved location. Are you sure you want to save another location?"),
                            primaryButton: .default(Text("Yes")) {
                                saveCarLocation()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    Spacer()
                }
                .padding()
                .offset(y: -offset)
                .animation(.easeOut(duration: 0.16))
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            self.offset = keyboardFrame.height / 2
                        }
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                        self.offset = 0
                    }
                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                }
            }
            .navigationBarTitle("Save Car Location", displayMode: .large)
            .padding()
            .background(backgroundColor.ignoresSafeArea())
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
    
    var colorsList: Color {
        switch switchColors {
        case .light:
            return Color.white
        case .dark:
            return Color(red: 51/255, green: 174/255, blue: 255/255)
        @unknown default:
            return Color.yellow.opacity(0.5)
            
        }
    }
    
    //MARK: handleButtonAction
    private func handleButtonAction() {
        let latitude = UserDefaults.standard.double(forKey: "latitude")
        let longitude = UserDefaults.standard.double(forKey: "longitude")
        
        if carLocation != nil {
            openMaps()
        } else {
            if latitude != 0 && longitude != 0 {
                showAlert = true
            } else {
                saveCarLocation()
            }
        }
    }
    
    //MARK: saveCarLocation
    private func saveCarLocation() {
        if let location = locationManager.userLocation {
            carLocation = location
            saveLocationToUserDefaults(location: location)
        }
    }
    
    //MARK: saveLocationToUserDefaults
    private func saveLocationToUserDefaults(location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let carModel = carIcon
        let referenceText = referenceText
        
        UserDefaults.standard.set(latitude, forKey: "latitude")
        UserDefaults.standard.set(longitude, forKey: "longitude")
        UserDefaults.standard.set(carModel, forKey: "carModel")
        UserDefaults.standard.set(referenceText, forKey: "referenceText")
        
    }
    
    //MARK: openMaps
    private func openMaps() {
        if let carLocation = carLocation {
            let coordinate = carLocation.coordinate
            let urlString = "http://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)&q=MyCar"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }
}


#Preview {
    saveLocation(carIcon: "car1")
}

