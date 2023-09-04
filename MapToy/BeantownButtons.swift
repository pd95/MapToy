//
//  BeantownButtons.swift
//  MapToy
//
//  Created by Philipp on 04.09.23.
//

import SwiftUI
import MapKit

struct BeantownButtons: View {

    @Binding var position: MapCameraPosition
    @Binding var searchResults: [MKMapItem]

    var visibleRegion: MKCoordinateRegion?

    var body: some View {
        HStack {
            Button {
                search(for: "playground")
            } label: {
                Label("Playgrounds", systemImage: "figure.and.child.holdinghands")
                    .imageScale(.large)
            }

            Button {
                search(for: "restaurant")
            } label: {
                Label("Restaurants", systemImage: "fork.knife")
                    .imageScale(.large)
            }

            Button {
                position = .church
            } label: {
                Label("Church", systemImage: "figure.mind.and.body")
                    .imageScale(.large)
            }

            Button {
                position = .region(.center)
            } label: {
                Label("City", systemImage: "building.2")
                    .imageScale(.large)
            }

            Button {
                position = .region(.city)
            } label: {
                Label("Overview", systemImage: "map")
                    .imageScale(.large)
            }
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
    }

    private func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion(
            center: .bridge,
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))

        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
}

#Preview {
    BeantownButtons(position: .constant(.automatic), searchResults: .constant([]))
}
