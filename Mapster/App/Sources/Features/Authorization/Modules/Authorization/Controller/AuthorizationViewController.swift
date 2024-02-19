//
//  AuthorizationViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 18.02.2024.
//

import UIKit
import SnapKit

protocol AuthorizationNavigationDelegate: AnyObject {
    func didFinishAuthorization(_ viewController: AuthorizationViewController)
}

final class AuthorizationViewController: UIViewController {
    enum ViewState {
        case authorization
        case registration
    }
    
    weak var navigationDelegate: AuthorizationNavigationDelegate?
    private var viewState: ViewState = .registration
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            nameTextField,
            phoneTextField,
            passwordTextField,
            checkBoxView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mapster"
        label.font = Font.mulish(name: .extraBold, size: 36)
        label.textColor = UIColor(named: "AccentColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Войдите в систему для доступа к своему аккаунту"
        label.font = Font.mulish(name: .light, size: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "TextField")
        textField.font = Font.mulish(name: .light, size: 14)
        textField.textColor = .black.withAlphaComponent(50)
        textField.rightView = UIImageView(image: .init(named: "user"))
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Номер телефона"
        textField.keyboardType = .phonePad
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "TextField")
        textField.font = Font.mulish(name: .light, size: 14)
        textField.textColor = .black.withAlphaComponent(50)
        textField.rightView = UIImageView(image: .init(named: "phone"))
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "TextField")
        textField.font = Font.mulish(name: .light, size: 14)
        textField.textColor = .black.withAlphaComponent(50)
        textField.rightView = UIImageView(image: .init(named: "lock"))
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "AccentColor")
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Font.mulish(name: .semiBold, size: 20)
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.setTitle("Зарегестрироваться", for: .normal)
        return button
    }()
    
    private lazy var checkBoxView: AuthorizationCheckboxView = {
        let checkBoxView = AuthorizationCheckboxView()
//        checkBoxView.delegate = self
        checkBoxView.configure(text: "Запомнить меня")
        return checkBoxView
    }()
    
    private let bottomTextView = UIView()
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "Уже есть аккаунт?"
        label.font = Font.mulish(name: .bold, size: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Войти"
        label.font = Font.mulish(name: .bold, size: 13)
        label.textAlignment = .center
        label.textColor = UIColor(named: "TextHighlight")
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    @objc
    private func actionButtonDidTap() {
        
    }
    
    private func setupViews() {
        [contentStackView, actionButton, bottomTextView].forEach { view.addSubview($0) }
        [accountLabel, loginLabel].forEach { bottomTextView.addSubview($0) }
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        phoneTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        actionButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        accountLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        loginLabel.snp.makeConstraints {
            $0.leading.equalTo(accountLabel.snp.trailing).offset(4)
            $0.trailing.top.bottom.equalToSuperview()
        }
        bottomTextView.snp.makeConstraints {
            $0.top.equalTo(actionButton.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
}

// MARK: - UITextFieldDelegate

extension AuthorizationViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        let numericPhoneNumber = textField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
//        let phoneNumberRegex = "^[0-9]{10}$"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
//        actionButton.isEnabled = predicate.evaluate(with: numericPhoneNumber)
//    }
//    
//    func formattedNumber(number: String) -> String {
//        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
//        let mask = "### ### ####"
//        var result = ""
//        var index = cleanPhoneNumber.startIndex
//        for ch in mask where index < cleanPhoneNumber.endIndex {
//            if ch == "#" {
//                result.append(cleanPhoneNumber[index])
//                index = cleanPhoneNumber.index(after: index)
//            } else {
//                result.append(ch)
//            }
//        }
//        return result
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string:  String) -> Bool {
//        guard let text = textField.text else { return false }
//        let newString = (text as NSString).replacingCharacters(in: range, with: string)
//        textField.text = formattedNumber(number: newString)
//        return false
//    }
}
