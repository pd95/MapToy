//
//  ItemInfoView.swift
//  MapToy
//
//  Created by Philipp on 04.09.23.
//

import SwiftUI
import MapKit

struct ItemInfoView: View {
    var selectedResult: MKMapItem
    var route: MKRoute?

    @State private var lookAroundScene: MKLookAroundScene?

    var body: some View {
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Text("\(selectedResult.name ?? "")")
                    if let travelTime {
                        Text(travelTime)
                    }
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(10)
            }
            .onAppear() {
                getLookAroundScene()
            }
            .onChange(of: selectedResult) {
                getLookAroundScene()
            }
    }

    private func getLookAroundScene() {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: selectedResult)
            lookAroundScene = try? await request.scene
        }
    }

    private var travelTime: String? {
        guard let route else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: route.expectedTravelTime)
    }
}

#Preview {
    ItemInfoView(selectedResult: .forCurrentLocation(), route: nil)
}
