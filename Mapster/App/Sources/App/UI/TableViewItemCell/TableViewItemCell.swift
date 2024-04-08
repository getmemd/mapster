//
//  TableViewItemCell.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import UIKit

final class TableViewItemCell: UITableViewCell {
    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, arrowImageView])
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .semiBold, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellModel: TableViewItemCellModel) {
        if let iconName = cellModel.iconName {
            iconImageView.image = UIImage(systemName: iconName)
        } else {
            iconImageView.isHidden = cellModel.iconName == nil
        }
        titleLabel.text = cellModel.title
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        contentBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        arrowImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
}
