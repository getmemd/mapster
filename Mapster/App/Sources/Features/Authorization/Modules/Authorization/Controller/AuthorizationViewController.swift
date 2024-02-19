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
    func didFinishRegistration(_ viewController: AuthorizationViewController)
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
            checkboxView
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
        textField.addPaddingAndIcon(.init(named: "user"), padding: 20, isLeftView: false)
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
        textField.addPaddingAndIcon(.init(named: "phone"), padding: 20, isLeftView: false)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "TextField")
        textField.font = Font.mulish(name: .light, size: 14)
        textField.textColor = .black.withAlphaComponent(50)
        textField.addPaddingAndIcon(.init(named: "lock"), padding: 20, isLeftView: false)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var actionButton: ActionButton = {
        let button = ActionButton()
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private lazy var checkboxView: AuthorizationCheckboxView = {
        let checkboxView = AuthorizationCheckboxView()
        checkboxView.delegate = self
        checkboxView.configure(with: .init(viewState: viewState))
        return checkboxView
    }()
    
    private let bottomTextView = UIView()
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "Уже есть аккаунт?"
        label.font = Font.mulish(name: .bold, size: 13)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Войти"
        label.font = Font.mulish(name: .bold, size: 13)
        label.textAlignment = .center
        label.textColor = UIColor(named: "TextHighlight")
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(loginDidTap))
        label.addGestureRecognizer(gesture)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    @objc
    private func actionButtonDidTap() {
        guard checkValidity() else { return }
        switch viewState {
        case .authorization:
            navigationDelegate?.didFinishAuthorization(self)
        case .registration:
            if checkPasswordValidity() {
                navigationDelegate?.didFinishRegistration(self)
            }
        }
    }
    
    @objc
    private func loginDidTap() {
        changeViewState()
    }
    
    private func changeViewState() {
        viewState = viewState == .authorization ? .registration : .authorization
        switch viewState {
        case .authorization:
            nameTextField.isHidden = true
            checkboxView.configure(with: .init(viewState: viewState))
            actionButton.setTitle("Войти", for: .normal)
            accountLabel.text = "Нет аккаунта?"
            loginLabel.text = "Зарегистрироваться"
        case .registration:
            nameTextField.isHidden = false
            checkboxView.configure(with: .init(viewState: viewState))
            actionButton.setTitle("Зарегистрироваться", for: .normal)
            accountLabel.text = "Уже есть аккаунт?"
            loginLabel.text = "Войти"
        }
    }
    
    private func checkValidity() -> Bool {
        checkPhoneNumberValidity() && !(passwordTextField.text?.isEmpty ?? true) && !(nameTextField.text?.isEmpty ?? true) && checkboxView.isSelected
    }
    
    private func checkPhoneNumberValidity() -> Bool {
        let numericPhoneNumber = phoneTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let phoneNumberRegex = "^[0-9]{11}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return predicate.evaluate(with: numericPhoneNumber)
    }
    
    private func checkPasswordValidity() -> Bool {
        let password = passwordTextField.text
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let status = predicate.evaluate(with: password)
        if !status {
            showPasswordAlert()
        }
        return status
    }
    
    func showPasswordAlert() {
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Пароль должен содержать минимум 8 символов, хотя бы 1 букву и 1 цифру",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        actionButton.isEnabled = checkValidity()
    }
    
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+# (###) ### ####"
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string:  String) -> Bool {
        guard textField == phoneTextField else { return true }
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
}

// MARK: - AuthorizationCheckboxViewDelegate

extension AuthorizationViewController: AuthorizationCheckboxViewDelegate {
    func didTapCheckbox(_ view: AuthorizationCheckboxView, isSelected: Bool) {
        actionButton.isEnabled = checkValidity()
    }
    
    func didTapForgotPassword(_ view: AuthorizationCheckboxView) {
        
    }
}
