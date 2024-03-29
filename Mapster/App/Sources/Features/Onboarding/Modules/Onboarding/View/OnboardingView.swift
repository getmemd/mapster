//
//  OnboardingView.swift
//  Mapster
//
//  Created by Адиль Медеуев on 15.02.2024.
//

import SnapKit
import UIKit

final class OnboardingView: UIView {
    private var contentView = UIView()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .extraBold, size: 36)
        label.numberOfLines = 0
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .light, size: 24)
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: OnboardingViewModel) {
        imageView.image = UIImage(named: viewModel.imageName)
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
    
    private func setupViews() {
        addSubview(contentView)
        [imageView, titleLabel, descriptionLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}
