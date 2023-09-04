//
//  MapToyApp.swift
//  MapToy
//
//  Created by Philipp on 04.09.23.
//

import SwiftUI

@main
struct MapToyApp: App {
    @StateObject private var locationManager = LocationDataManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    locationManager.checkAuthorization()
                })
                .environmentObject(locationManager)
        }
    }
}
