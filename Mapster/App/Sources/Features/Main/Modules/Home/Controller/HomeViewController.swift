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
    var navigationDelegate: HomeNavigationDelegate?
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
        tabBarController?.selectedIndex = 0
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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            guard let location = manager.location else { return }
            centerToLocation(location)
        case .notDetermined:
            break
        default:
            presentPermissionDeniedAlert()
        }
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
        let alert = UIAlertController(title: "Требуется доступ к геолокации",
                                      message: "Для полной функциональности приложения требуется доступ к вашему местоположению.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
