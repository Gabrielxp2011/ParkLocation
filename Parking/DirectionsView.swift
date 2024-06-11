//
//  DirectionsView.swift
//  Parking
//
//  Created by Gabriel Xavier on 2024-06-11.
//

import SwiftUI
import MapKit

struct DirectionsView: View {
    var carLocation: CLLocation
    @State private var region = MKCoordinateRegion()
    @State private var directions: [String] = []

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .onAppear {
                    setRegion(carLocation)
                    getDirections()
                }
            List(directions, id: \.self) { direction in
                Text(direction)
            }
        }
    }

    private func setRegion(_ location: CLLocation) {
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    private func getDirections() {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: carLocation.coordinate))
        request.transportType = .walking

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let response = response {
                self.directions = response.routes.first?.steps.map { $0.instructions }.filter { !$0.isEmpty } ?? []
            }
        }
    }
}
