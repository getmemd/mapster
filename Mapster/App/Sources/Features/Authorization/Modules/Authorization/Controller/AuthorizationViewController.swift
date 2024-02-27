//
//  AuthorizationViewController.swift
//  Mapster
//
//  Created by User on 18.02.2024.
//

import UIKit
import SnapKit

// Протокол делегата навигации по экрану авторизации, определяющий методы для обратного вызова
protocol AuthorizationNavigationDelegate: AnyObject {
    // Метод вызывается после завершения операции авторизации
    func didFinishAuthorization(_ viewController: AuthorizationViewController)
    // Метод вызывается после завершения операции регистрации
    func didFinishRegistration(_ viewController: AuthorizationViewController)
    func didTapForgotPassword(_ viewController: AuthorizationViewController)
}

final class AuthorizationViewController: UIViewController {
    // Перечисление для представления состояний экрана (авторизация или регистрация)
    enum ViewState {
        case authorization
        case registration
    }
    
    // Слабая ссылка на делегата навигации
    weak var navigationDelegate: AuthorizationNavigationDelegate?
    // Текущее состояние экрана
    private var viewState: ViewState = .registration
    
    // Стек видов для отображения содержимого экрана
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            nameTextField,
            phoneTextField,
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
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Имя"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "TextField")
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(named: "user"), padding: 20, isLeftView: false)
        return textField
    }()
    
    // Текстовое поле для ввода номера телефона
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Номер телефона"
        textField.keyboardType = .phonePad
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "TextField")
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(named: "phone"), padding: 20, isLeftView: false)
        return textField
    }()
    
    // Текстовое поле для ввода пароля
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "TextField")
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
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(named: "lock"), padding: 20, isLeftView: false)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // Кнопка действия (вход или регистрация)
    private lazy var actionButton: ActionButton = {
        let button = ActionButton()
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    // Вид с чекбоксом для пользовательского соглашения
    private lazy var checkboxView: AuthorizationCheckboxView = {
        let checkboxView = AuthorizationCheckboxView()
        checkboxView.delegate = self
        checkboxView.configure(with: .init(viewState: viewState))
        return checkboxView
    }()
    
    // Вид с ссылками для авторизации или регистрации
    private let bottomTextView = UIView()
    
    // Лейбл "Уже есть аккаунт?"
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "Уже есть аккаунт?"
        label.font = Font.mulish(name: .bold, size: 13)
        label.textAlignment = .center
        return label
    }()
    
    // Лейбл с текстом ссылки (Войти или Зарегистрироваться)
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
    
    // Метод вызывается после загрузки представления
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // Обработчик нажатия кнопки действия (вход или регистрация)
    @objc
    private func actionButtonDidTap() {
        guard checkValidity() else { return }
        switch viewState {
        case .authorization:
            navigationDelegate?.didFinishAuthorization(self)
        case .registration:
            guard let password = passwordTextField.text,
                  let repeatPassword = repeatPasswordTextField.text else { return }
            do {
                try PasswordValidatationService.checkPasswordValidity(password: password, repeatPassword: repeatPassword)
                navigationDelegate?.didFinishRegistration(self)
            } catch let error as PasswordError {
                showPasswordAlert(message: error.failureReason)
            } catch {
                return
            }
        }
    }
    
    // Обработчик нажатия ссылки для переключения между режимами
    @objc
    private func loginDidTap() {
        changeViewState()
    }
    
    // Метод изменяет текущее состояние экрана (режим авторизации или регистрации)
    private func changeViewState() {
        viewState = viewState == .authorization ? .registration : .authorization
        switch viewState {
        case .authorization:
            nameTextField.isHidden = true
            repeatPasswordTextField.isHidden = true
            checkboxView.configure(with: .init(viewState: viewState))
            actionButton.setTitle("Войти", for: .normal)
            accountLabel.text = "Нет аккаунта?"
            loginLabel.text = "Зарегистрироваться"
        case .registration:
            nameTextField.isHidden = false
            repeatPasswordTextField.isHidden = false
            checkboxView.configure(with: .init(viewState: viewState))
            actionButton.setTitle("Зарегистрироваться", for: .normal)
            accountLabel.text = "Уже есть аккаунт?"
            loginLabel.text = "Войти"
        }
    }
    
    // Метод проверяет валидность введенных данных
    private func checkValidity() -> Bool {
        switch viewState {
        case .authorization:
            return checkPhoneNumberValidity() && !(passwordTextField.text?.isEmpty ?? true)
        case .registration:
            return checkPhoneNumberValidity() &&
            !(passwordTextField.text?.isEmpty ?? true) &&
            !(repeatPasswordTextField.text?.isEmpty ?? true) &&
            !(nameTextField.text?.isEmpty ?? true) &&
            checkboxView.isSelected
        }
    }
    
    // Метод проверяет валидность введенного номера телефона
    private func checkPhoneNumberValidity() -> Bool {
        let numericPhoneNumber = phoneTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let phoneNumberRegex = "^[0-9]{11}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return predicate.evaluate(with: numericPhoneNumber)
    }
    
    private func showPasswordAlert(message: String?) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Метод настраивает внешний вид экрана
    private func setupViews() {
        [contentStackView, actionButton, bottomTextView].forEach { view.addSubview($0) }
        [accountLabel, loginLabel].forEach { bottomTextView.addSubview($0) }
        view.backgroundColor = .white
    }
    
    // Метод настраивает ограничения для элементов интерфейса
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
    // Метод вызывается после окончания редактирования текстового поля
    func textFieldDidEndEditing(_ textField: UITextField) {
        actionButton.isEnabled = checkValidity()
    }
    
    // Метод форматирует введенный номер телефона
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
    
    // Метод определяет, разрешено ли изменение введенных символов в текстовом поле
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
    // Метод вызывается при нажатии на чекбокс
    func didTapCheckbox(_ view: AuthorizationCheckboxView, isSelected: Bool) {
        actionButton.isEnabled = checkValidity()
    }
    
    // Метод вызывается при нажатии на ссылку "Забыли пароль?"
    func didTapForgotPassword(_ view: AuthorizationCheckboxView) {
        navigationDelegate?.didTapForgotPassword(self)
    }
}
