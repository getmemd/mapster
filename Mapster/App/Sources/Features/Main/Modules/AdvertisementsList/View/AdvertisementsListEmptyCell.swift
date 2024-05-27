//
//  AdvertisementsListEmptyCell.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

final class AdvertisementsListEmptyCell: UITableViewCell {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет избранных"
        label.font = Font.mulish(name: .bold, size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .regular, size: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellModel: AdvertisementsListEmptyCellModel) {
        iconImageView.image = .init(named: cellModel.iconName)
        titleLabel.text = cellModel.title
        subtitleLabel.text = cellModel.subtitle
    }
    
    private func setupViews() {
        backgroundColor = .clear
        [iconImageView, titleLabel, subtitleLabel].forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        iconImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
}
