//
//  CreateTextViewCell.swift
//  Mapster
//
//  Created by User on 07.04.2024.
//

import UIKit

protocol CreateTextViewCellDelegate: AnyObject {
    func didEndEditing(_ cell: CreateTextViewCell, text: String?)
}

final class CreateTextViewCell: UITableViewCell {
    weak var delegate: CreateTextViewCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .semiBold, size: 16)
        label.text = "Описание*"
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.font = Font.mulish(name: .regular, size: 14)
        textView.backgroundColor = .textField
        textView.layer.cornerRadius = 10
        textView.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        textView.text = "Расскажите о продукте..."
        return textView
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .regular, size: 14)
        label.text = "0/9000"
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
    
    func configure(text: String?) {
        textView.text = text
    }
    
    private func setupViews() {
        backgroundColor = .clear
        [titleLabel, textView, counterLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        textView.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        counterLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
}

extension CreateTextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        counterLabel.text = "\(count)/9000"
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text.count < 9000
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didEndEditing(self, text: textView.text)
    }
}
