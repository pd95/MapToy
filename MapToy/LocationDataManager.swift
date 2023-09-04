//
//  LocationDataManager.swift
//  MapToy
//
//  Created by Philipp on 04.09.23.
//

import Foundation
import CoreLocation

class LocationDataManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private var locationManager = CLLocationManager()

    @Published private(set) var isAuthorized = false

    var state: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func checkAuthorization() {
        isAuthorized = locationManager.authorizationStatus == .authorizedWhenInUse
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, manager.authorizationStatus.rawValue)
        checkAuthorization()
    }
}
