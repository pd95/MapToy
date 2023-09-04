//
//  ContentView.swift
//  MapToy
//
//  Created by Philipp on 04.09.23.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let bridge = CLLocationCoordinate2D(latitude: 47.36691, longitude: 8.5430)
    static let harbor = CLLocationCoordinate2D(latitude: 47.36542, longitude: 8.54119)
    static let person = CLLocationCoordinate2D(latitude: 47.36758, longitude: 8.54239)
}

extension MKCoordinateRegion {
    static let city = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.36930, longitude: 8.54181),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

    static let center = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.37182, longitude: 8.54288),
        span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
    )
}

extension MapCameraPosition {
    static let church: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 47.370084, longitude: 8.544053),
            distance: 500, heading: 100, pitch: 80
        )
    )
}



struct ContentView: View {
    @EnvironmentObject var locationManager: LocationDataManager

    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var visibleRegion: MKCoordinateRegion?

    @State private var searchResults: [MKMapItem] = []
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?

    var body: some View {
        if locationManager.isAuthorized == false {
            UserLocationAuthorization(state: locationManager.state)
        } else {
            Map(position: $position, selection: $selectedResult) {
                UserAnnotation()
                if searchResults.isEmpty {
                    Marker("Bridge", coordinate: .bridge)
                    Marker("Harbor", systemImage: "sailboat.fill", coordinate: .harbor)
                    Annotation("Sign-in", coordinate: .person) {
                        Image(systemName: "figure.wave")
                            .padding(4)
                            .foregroundStyle(.white)
                            .background(.indigo)
                            .cornerRadius(4)
                    }
                }

                ForEach(searchResults, id: \.self) { result in
                    Marker(item: result)
                }
                .annotationTitles(.hidden)

                if let route {
                    MapPolyline(route)
                        .stroke(.blue, lineWidth: 5)
                }
            }
            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: [.museum, .nationalPark, .park, .theater, .zoo]))
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
                MapPitchToggle()
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    VStack(spacing: 0) {
                        if let selectedResult {
                            ItemInfoView(selectedResult: selectedResult, route: route)
                                .frame(height: 128)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding([.top, .horizontal])
                        }
                        BeantownButtons(position: $position, searchResults: $searchResults, visibleRegion: visibleRegion)
                            .padding(.top)
                    }
                    Spacer()
                }
                .background(.ultraThinMaterial)
            }
            .onChange(of: searchResults) {
                position = .automatic
            }
            .onChange(of: selectedResult, {
                getDirections()
            })
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .animation(.spring, value: position)
        }
    }

    func getDirections() {
        route = nil
        guard let selectedResult else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .bridge))
        request.destination = selectedResult

        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationDataManager())
}
