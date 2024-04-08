//
//  HomeViewController.swift
//  Mapster
//
//  Created by User on 26.02.2024.
//

import CoreLocation
import MapKit
import SnapKit
import UIKit

protocol HomeNavigationDelegate: AnyObject {
    
}

final class HomeViewController: BaseViewController {
    var navigationDelegate: HomeNavigationDelegate?
    private lazy var store = HomeStore()
    private var bag = Bag()
    
    // Представление карты
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
        configureObservers()
        store.handleAction(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LocationDataManager.shared.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LocationDataManager.shared.stop()
    }
    
    private func setAnnotations(coordinates: [CLLocationCoordinate2D]) {
        coordinates.forEach {
            let annotation = MKPointAnnotation()
            annotation.coordinate = $0
            mapView.addAnnotation(annotation)
        }
    }
    
    private func centerToLocation(_ location: CLLocation,
                                  regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func presentPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Для корректного отображения местоположения требуется:",
            message: "Предоставить приложению доступ к геолокации в разделе Настройки - Конфиденциальность - Службы геолокации - Mapster - Разрешить доступ к геопозиции",
            preferredStyle: .alert
        )
        alert.addAction(
            .init(title: "Открыть настройки", style: .default) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            }
        )
        alert.addAction(.init(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
    private func configureObservers() {
        bindStore(store) { [weak self ] event in
            guard let self else { return }
            switch event {
            case let .advertisements(coordinates):
                setAnnotations(coordinates: coordinates)
            case let .showError(message):
                showAlert(message: message)
            case .loading:
                activityIndicator.startAnimating()
            case .loadingFinished:
                activityIndicator.stopAnimating()
            }
        }
        .store(in: &bag)
    }
    
    private func setupViews() {
        tabBarItem = .init(title: "Главная", image: .init(named: "home"), tag: 0)
        tabBarController?.selectedIndex = 0
        view.addSubview(mapView)
        guard let location = LocationDataManager.shared.getCurrentLocation() else {
            presentPermissionDeniedAlert()
            return
        }
        centerToLocation(location)
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - MKMapViewDelegate

extension HomeViewController: MKMapViewDelegate {
    
}
