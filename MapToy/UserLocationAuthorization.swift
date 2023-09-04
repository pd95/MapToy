//
//  UserLocationAuthorization.swift
//  MapToy
//
//  Created by Philipp on 04.09.23.
//

import SwiftUI
import CoreLocation

struct UserLocationAuthorization: View {
    @EnvironmentObject private var locationManager: LocationDataManager

    let state: CLAuthorizationStatus

    var body: some View {
        switch state {
        case .notDetermined:
            VStack {
                Text("This app wants to access your current location to show relevant information.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("Grant access") {
                    locationManager.requestAuthorization()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()

        case .restricted:
            VStack {
                Text("""
                    Access to your location is restricted. This may be due to parental control.
                    If you want to use this app you will have to enable location services.
                    """
                ).frame(maxWidth: .infinity, alignment: .leading)
                    .border(.red)
                openSettingsButton
            }
            .padding()

        case .denied:
            VStack {
                Text("""
                    You have previously denied access to your location.
                    If you want to use this app you will have to enable location services.
                    """
                ).frame(maxWidth: .infinity, alignment: .leading)
                    .border(.red)
                openSettingsButton
            }
            .padding()

        default:

            VStack {
                Text("Unexpected state is: \(String(describing: state))")
                openSettingsButton
            }
            .padding()
        }
    }

    private var openSettingsButton: some View {
        Button("Open Settings app") {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        .buttonStyle(.borderedProminent)
    }
}


#Preview("Not determined") {
    UserLocationAuthorization(state: .notDetermined)
}
#Preview("Restricted") {
    UserLocationAuthorization(state: .restricted)
}
#Preview("Denied") {
    UserLocationAuthorization(state: .denied)
}
