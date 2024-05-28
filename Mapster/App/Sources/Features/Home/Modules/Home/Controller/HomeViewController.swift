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
    func didTapAdvertisement(_ viewController: HomeViewController, advertisement: Advertisement)
}

final class HomeViewController: BaseViewController {
    weak var navigationDelegate: HomeNavigationDelegate?
    private lazy var store = HomeStore()
    private var bag = Bag()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        mapView.register(HomeAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        return mapView
    }()
    
    private let refreshBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var refreshImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "arrow.clockwise")
        imageView.tintColor = .accent
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(refreshData))
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureObservers()
        store.handleAction(.loadData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LocationDataManager.shared.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LocationDataManager.shared.stop()
    }
    
    private func setAnnotations(viewModels: [HomeAnnotationViewModel]) {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = viewModels.enumerated().map { index, viewModel -> HomePointAnnotation in
            let annotation = HomePointAnnotation()
            annotation.tag = index
            annotation.coordinate = viewModel.coordinates
            annotation.pinIcon = UIImage(systemName: viewModel.icon)
            annotation.title = viewModel.title
            annotation.subtitle = viewModel.subtitle
            return annotation
        }
        mapView.addAnnotations(annotations)
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
            case let .advertisements(viewModels):
                setAnnotations(viewModels: viewModels)
            case let .showError(message):
                showAlert(message: message)
            case .loading:
                ProgressHud.startAnimating()
            case .loadingFinished:
                ProgressHud.stopAnimating()
            case let .annotationSelected(advertisement):
                navigationDelegate?.didTapAdvertisement(self, advertisement: advertisement)
            }
        }
        .store(in: &bag)
    }
    
    private func setupViews() {
        tabBarController?.selectedIndex = 0
        view.addSubview(mapView)
        refreshBackgroundView.addSubview(refreshImageView)
        view.addSubview(refreshBackgroundView)
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
        refreshBackgroundView.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(5)
        }
        refreshImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Updatable

extension HomeViewController: Updatable {
    @objc
    func refreshData() {
        store.handleAction(.loadData)
    }
}

// MARK: - MKMapViewDelegate

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let annotationView: HomeAnnotationView? = mapView.dequeueReusableAnnotationView(
            withIdentifier: "HomeAnnotation"
        ) as? HomeAnnotationView ?? HomeAnnotationView(
            annotation: annotation,
            reuseIdentifier: "HomeAnnotation"
        )
        annotationView?.delegate = self
        return annotationView
    }
}

// MARK: - HomeAnnotationViewDelegate

extension HomeViewController: HomeAnnotationViewDelegate {
    func didTapCalloutButton(_ view: HomeAnnotationView) {
        guard let tag = (view.annotation as? HomePointAnnotation)?.tag else { return }
        store.handleAction(.didTapAnnotation(index: tag))
    }
}
