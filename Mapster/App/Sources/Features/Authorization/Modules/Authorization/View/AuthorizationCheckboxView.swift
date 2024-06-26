//
//  AuthorizationCheckboxView.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 18.02.2024.
//

import SnapKit
import UIKit

protocol AuthorizationCheckboxViewDelegate: AnyObject {
    func didTapForgotPassword(_ view: AuthorizationCheckboxView)
}

final class AuthorizationCheckboxView: UIView {
    weak var delegate: AuthorizationCheckboxViewDelegate?
    
    var isSelected: Bool {
        checkBoxButton.isSelected
    }
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkBoxButton, textView, forgotPasswordLabel])
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
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        textView.font = Font.mulish(name: .light, size: 12)
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.tintColor = .textHighlight
        let attributedString = NSMutableAttributedString()
        attributedString.mutableString.setString("Я ознакомлен и согласен с условиями использования.")
        attributedString.addAttribute(.link,
                                      value: "https://www.apple.com",
                                      range: NSRange(location: 26, length: 23))
        textView.attributedText = attributedString
        return textView
    }()
    
    private lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Забыли пароль?"
        label.textAlignment = .right
        label.font = Font.mulish(name: .light, size: 12)
        label.textColor = .textHighlight
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordDidTap))
        label.addGestureRecognizer(gesture)
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
    
    func configure(with viewModel: AuthorizationCheckoxViewModel) {
        textView.isHidden = !viewModel.isRegistration
        checkBoxButton.isHidden = !viewModel.isRegistration
        forgotPasswordLabel.isHidden = viewModel.isRegistration
    }
    
    @objc
    private func forgotPasswordDidTap() {
        delegate?.didTapForgotPassword(self)
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
            $0.size.equalTo(16)
        }
    }
}
