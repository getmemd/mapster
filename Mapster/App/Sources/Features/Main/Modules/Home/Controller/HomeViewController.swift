//
//  HomeViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 26.02.2024.
//

import CoreLocation
import MapKit
import SnapKit
import UIKit

protocol HomeNavigationDelegate: AnyObject {
    
}

final class HomeViewController: UIViewController {
    weak var navigationDelegate: HomeNavigationDelegate?
    private var locationManager: CLLocationManager?
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        attemptLocationAccess()
    }
    
    private func setupViews() {
        tabBarItem = .init(title: "Главная", image: .init(named: "home"), tag: 0)
        view.addSubview(mapView)
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        guard let location = locations.last else {
            presentPermissionDeniedAlert()
            return
        }
        getGeoLocation(location: location)
    }
    
    private func stopLocationManager() {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    private func attemptLocationAccess() {
        createLocationManager()
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager?.requestWhenInUseAuthorization()
            } else {
                self?.presentPermissionDeniedAlert()
            }
        }
    }
    
    private func createLocationManager() {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager = manager
    }
    
    private func presentPermissionDeniedAlert() {
        stopLocationManager()
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Приложению требуется доступ к геолокации",
                                      preferredStyle: .alert)
        present(alert, animated: true)
    }
    
    private func getGeoLocation(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: .current) { [weak self] placemarks, _ in
            guard placemarks?.first?.isoCountryCode != "KZ" else {
                self?.stopLocationManager()
                self?.centerToLocation(location)
                return
            }
//            self?.alertCompletion()
            print("Alert")
        }
    }
}

// MARK: - MKMapViewDelegate

extension HomeViewController: MKMapViewDelegate {
    func centerToLocation(_ location: CLLocation,
                          regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
