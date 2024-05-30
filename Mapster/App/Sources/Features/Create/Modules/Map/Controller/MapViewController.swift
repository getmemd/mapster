import MapKit
import UIKit

protocol MapNavigationDelegate: AnyObject {
    func didTapActionButton(_ viewController: MapViewController, latitude: Double, longitude: Double)
}

final class MapViewController: BaseViewController {
    weak var navigationDelegate: MapNavigationDelegate?
    private var locationManager: CLLocationManager?
    
    private var coordinate: CLLocationCoordinate2D?
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapRecognizer)
        return mapView
    }()
    
    private lazy var actionButton: ActionButton = {
        let button = ActionButton()
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.setTitle("Подтвердить", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    @objc
    private func actionButtonDidTap() {
        guard let coordinate else { return }
        navigationDelegate?.didTapActionButton(self, latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    @objc
    private func handleMapTap(_ gestureReconizer: UITapGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        self.coordinate = coordinate
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        actionButton.isEnabled = true
    }
    
    private func setupViews() {
        [mapView, actionButton].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        actionButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
}
