//
//  FavouritesEmptyCell.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import UIKit

// Ячейка для отображения отсутствия объявлений
final class FavouritesEmptyCell: UITableViewCell {
    private let favouritesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(named: "favourites-empty")
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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Сохраняйте объявления, которые вас заинтересовало, и мы сохраним его здесь."
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
    
    private func setupViews() {
        backgroundColor = .clear
        [favouritesImageView, titleLabel, descriptionLabel].forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        favouritesImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(favouritesImageView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
}
