//
//  HomeAnnotationView.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 10.05.2024.
//

import MapKit

protocol HomeAnnotationViewDelegate: AnyObject {
    func didTapCalloutButton(_ view: HomeAnnotationView)
}

final class HomeAnnotationView: MKAnnotationView {
    weak var delegate: HomeAnnotationViewDelegate?
    
    override var annotation: MKAnnotation? {
        didSet {
            configure(for: annotation)
        }
    }
    
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure(for: annotation)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        view.layer.cornerRadius = 18
        return view
    }()
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @objc
    private func didTapCalloutButton() {
        delegate?.didTapCalloutButton(self)
    }
    
    private func configure(for annotation: MKAnnotation?) {
        iconView.image = (annotation as? HomePointAnnotation)?.pinIcon
    }
    
    private func setupCalloutButton() {
        let button = UIButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(didTapCalloutButton), for: .touchUpInside)
        rightCalloutAccessoryView = button
    }
    
    private func setupView() {
        canShowCallout = true
        addSubview(circleView)
        circleView.addSubview(iconView)
        setupCalloutButton()
    }
    
    private func setupConstraints() {
        circleView.snp.makeConstraints {
            $0.size.equalTo(36)
            $0.center.equalToSuperview()
        }
        iconView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.center.equalToSuperview()
        }
    }
}
