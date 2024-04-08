//
//  LocationDataManager.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 08.04.2024.
//

import CoreLocation
import UIKit

@MainActor
final class LocationDataManager: NSObject, ObservableObject {
    static let shared = LocationDataManager()
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func getCurrentLocation() -> CLLocation? {
        locationManager.location
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationDataManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            break
        default:
            break
        }
    }
}
