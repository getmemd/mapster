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

final class AuthorizationViewController: BaseViewController {
    var navigationDelegate: AuthorizationNavigationDelegate?
    private let store = AuthStore()
    private var bag = Bag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            emailTextField,
            passwordTextField,
            repeatPasswordTextField,
            checkboxView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mapster"
        label.font = Font.mulish(name: .extraBold, size: 36)
        label.textColor = UIColor(named: "AccentColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Войдите в систему для доступа к своему аккаунту"
        label.font = Font.mulish(name: .light, size: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "TextField")
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(named: "user"), padding: 20, isLeftView: false)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "TextField")
        textField.textContentType = .password
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(named: "lock"), padding: 20, isLeftView: false)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Повторите пароль"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "TextField")
        textField.textContentType = .password
        textField.font = Font.mulish(name: .light, size: 14)
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
        checkboxView.configure(with: .init(isRegistration: store.isRegistration))
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
        configureObservers()
        setupViews()
        setupConstraints()
    }
    
    @objc
    private func actionButtonDidTap() {
        guard checkValidity(),
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        if store.isRegistration {
            guard let repeatPassword = repeatPasswordTextField.text else { return }
            do {
                try PasswordValidatationService.checkPasswordValidity(password: password, repeatPassword: repeatPassword)
                store.handleAction(.actionButtonDidTap(email: email, password: password))
            } catch let error as PasswordError {
                showAlert(message: error.failureReason)
            } catch {
                return
            }
        } else {
            store.handleAction(.actionButtonDidTap(email: email, password: password))
        }
    }
    
    @objc
    private func loginDidTap() {
        changeViewState()
    }
    
    private func changeViewState() {
        store.isRegistration.toggle()
        repeatPasswordTextField.isHidden = !store.isRegistration
        checkboxView.configure(with: .init(isRegistration: store.isRegistration))
        actionButton.setTitle(store.isRegistration ? "Зарегистрироваться" : "Войти", for: .normal)
        accountLabel.text = store.isRegistration ? "Уже есть аккаунт?" : "Нет аккаунта?"
        loginLabel.text = store.isRegistration ? "Войти?" : "Зарегистрироваться"
    }
    
    private func checkValidity() -> Bool {
        if store.isRegistration {
            return isValidEmail() &&
            !(passwordTextField.text?.isEmpty ?? true) &&
            !(repeatPasswordTextField.text?.isEmpty ?? true) &&
            checkboxView.isSelected
        } else {
            return isValidEmail() && !(passwordTextField.text?.isEmpty ?? true)
        }
    }
    
    private func isValidEmail() -> Bool {
        guard let email = emailTextField.text else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func configureObservers() {
        bindStore(store) { [weak self ] event in
            guard let self else { return }
            switch event {
            case .loading:
                activityIndicator.startAnimating()
            case .loadingFinished:
                activityIndicator.stopAnimating()
            case let .showAlert(title, message):
                showAlert(title: title, message: message)
            case .success:
                navigationDelegate?.didFinishAuthorization(self)
            }
        }
        .store(in: &bag)
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
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        repeatPasswordTextField.snp.makeConstraints {
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
}

// MARK: - AuthorizationCheckboxViewDelegate

extension AuthorizationViewController: AuthorizationCheckboxViewDelegate {
    func didTapCheckbox(_ view: AuthorizationCheckboxView, isSelected: Bool) {
        actionButton.isEnabled = checkValidity()
    }
    
    func didTapForgotPassword(_ view: AuthorizationCheckboxView) {
        guard let email = emailTextField.text, isValidEmail() else {
            showAlert(message: "Введите свой email")
            return
        }
        store.sendAction(.resetPasswordDidTap(email: email))
    }
}
