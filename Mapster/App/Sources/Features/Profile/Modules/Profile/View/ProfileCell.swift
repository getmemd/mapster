//
//  ProfileCell.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 21.05.2024.
//

import UIKit

final class ProfileCell: UITableViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .extraBold, size: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .regular, size: 16)
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
    
    func configure(name: String?, phoneNumber: String?) {
        nameLabel.text = name
        phoneNumberLabel.text = phoneNumber
    }
    
    private func setupViews() {
        backgroundColor = .clear
        [nameLabel, phoneNumberLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        phoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
