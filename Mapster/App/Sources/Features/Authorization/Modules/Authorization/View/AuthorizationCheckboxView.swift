//
//  AuthorizationCheckboxView.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 18.02.2024.
//

import SnapKit
import UIKit

final class AuthorizationCheckboxView: UIView {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkBoxButton, textView])
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
        button.setImage(UIImage(named: "checkbox_checked"), for: .selected)
        button.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        textView.font = Font.mulish(name: .regular, size: 9)
        return textView
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        textView.text = text
    }
    
    @objc
    private func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    private func setupViews() {
        addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        checkBoxButton.snp.makeConstraints {
            $0.size.equalTo(12)
        }
    }
}
