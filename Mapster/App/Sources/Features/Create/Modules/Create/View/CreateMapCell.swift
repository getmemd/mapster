import Firebase
import MapKit
import UIKit

protocol CreateMapCellDelegate: AnyObject {
    func didTapActionButton(_ cell: CreateMapCell)
    func didTapMap(_ cell: CreateMapCell)
}

final class CreateMapCell: UITableViewCell {
    weak var delegate: CreateMapCellDelegate?
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.cornerRadius = 10
        let gesture = UITapGestureRecognizer(target: self, action: #selector(mapDidTap))
        mapView.addGestureRecognizer(gesture)
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        return mapView
    }()
    
    private lazy var actionButton: ActionButton = {
        let button = ActionButton()
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.setTitle("Опубликовать", for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func actionButtonDidTap() {
        delegate?.didTapActionButton(self)
    }
    
    @objc
    private func mapDidTap() {
        delegate?.didTapMap(self)
    }
    
    func configure(geopoint: GeoPoint?) {
        mapView.removeAnnotations(mapView.annotations)
        guard let geopoint else { return }
        let location = CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func setupViews() {
        backgroundColor = .clear
        [mapView, actionButton].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() { 
        mapView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(200)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        actionButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(mapView.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
}
