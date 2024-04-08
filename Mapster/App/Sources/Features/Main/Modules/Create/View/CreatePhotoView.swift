//
//  CreatePhotoView.swift
//  Mapster
//
//  Created by User on 07.04.2024.
//

import UIKit

protocol CreatePhotoViewDelegate: AnyObject {
    func didTapDelete(_ view: CreatePhotoView)
}

final class CreatePhotoView: UIView {
    weak var delegate: CreatePhotoViewDelegate?
    
    private lazy var deleteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapDelete))
        imageView.addGestureRecognizer(gesture)
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
    
    @objc
    private func didTapDelete() {
        delegate?.didTapDelete(self)
    }
    
    private func setupViews() { 
        [imageView, deleteImageView].forEach { addSubview($0) }
    }
    
    private func setupConstraints() { 
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(150)
        }
        deleteImageView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(16)
        }
    }
}
