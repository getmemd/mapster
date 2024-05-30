import UIKit
import SnapKit

protocol AuthorizationNavigationDelegate: AnyObject {
    func didFinishAuthorization(_ viewController: AuthorizationViewController)
}

final class AuthorizationViewController: BaseViewController {
    weak var navigationDelegate: AuthorizationNavigationDelegate?
    private let store = AuthStore()
    private var bag = Bag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            nameTextField,
            emailTextField,
            phoneNumberTextField,
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
        label.textColor = .accent
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
        textField.keyboardType = .namePhonePad
        textField.autocapitalizationType = .words
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .textField
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(named: "user"), padding: 20, isLeftView: false)
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .textField
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(named: "user"), padding: 20, isLeftView: false)
        return textField
    }()
    
    private lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Телефон"
        textField.keyboardType = .phonePad
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .textField
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(named: "phone"), padding: 20, isLeftView: false)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .textField
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
        textField.backgroundColor = .textField
        textField.textContentType = .newPassword
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(named: "lock"), padding: 20, isLeftView: false)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var actionButton: ActionButton = {
        let button = ActionButton()
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.setTitle("Зарегистрироваться", for: .normal)
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
        label.textColor = .textHighlight
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
        guard checkValidity(), let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(message: "Заполните все поля")
            return
        }
        if store.isRegistration {
            guard let repeatPassword = repeatPasswordTextField.text else {
                showAlert(message: "Необходимо повторить пароль")
                return
            }
            handleRegistration(email: email, password: password, repeatPassword: repeatPassword)
        } else {
            handleLogin(email: email, password: password)
        }
    }

    private func handleRegistration(email: String, password: String, repeatPassword: String) {
        do {
            try ValidatationService.checkPasswordValidity(password: password, repeatPassword: repeatPassword)
            store.handleAction(
                .actionButtonDidTap(
                    email: email,
                    password: password,
                    name: nameTextField.text,
                    phoneNumber: phoneNumberTextField.text
                )
            )
        } catch let error as PasswordError {
            showAlert(message: error.failureReason)
        } catch {
            showAlert(message: "Произошла неизвестная ошибка")
        }
    }

    private func handleLogin(email: String, password: String) {
        store.handleAction(.actionButtonDidTap(email: email, password: password))
    }

    @objc
    private func loginDidTap() {
        changeViewState()
    }
    
    private func changeViewState() {
        store.isRegistration.toggle()
        nameTextField.isHidden = !store.isRegistration
        phoneNumberTextField.isHidden = !store.isRegistration
        repeatPasswordTextField.isHidden = !store.isRegistration
        checkboxView.configure(with: .init(isRegistration: store.isRegistration))
        actionButton.setTitle(store.isRegistration ? "Зарегистрироваться" : "Войти", for: .normal)
        accountLabel.text = store.isRegistration ? "Уже есть аккаунт?" : "Нет аккаунта?"
        loginLabel.text = store.isRegistration ? "Войти?" : "Зарегистрироваться"
    }
    
    private func checkValidity() -> Bool {
        if store.isRegistration {
            return !(nameTextField.text?.isEmpty ?? true) &&
            ValidatationService.checkPhoneNumberValidity(phoneNumber: phoneNumberTextField.text) &&
            isValidEmail() &&
            !(passwordTextField.text?.isEmpty ?? true) &&
            !(repeatPasswordTextField.text?.isEmpty ?? true) &&
            checkboxView.isSelected
        } else {
            return isValidEmail() && !(passwordTextField.text?.isEmpty ?? true)
        }
    }
    
    private func checkPhoneNumberValidity() -> Bool {
        let numericPhoneNumber = phoneNumberTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let phoneNumberRegex = "^[0-9]{11}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return predicate.evaluate(with: numericPhoneNumber)
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
                ProgressHud.startAnimating()
            case .loadingFinished:
                ProgressHud.stopAnimating()
            case let .showAlert(title, message, completion):
                showAlert(title: title, message: message, completion: completion)
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
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        phoneNumberTextField.snp.makeConstraints {
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
        guard textField == phoneNumberTextField else { return true }
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
}

// MARK: - AuthorizationCheckboxViewDelegate

extension AuthorizationViewController: AuthorizationCheckboxViewDelegate {
    func didTapForgotPassword(_ view: AuthorizationCheckboxView) {
        guard let email = emailTextField.text, isValidEmail() else {
            showAlert(message: "Введите свой email")
            return
        }
        store.sendAction(.resetPasswordDidTap(email: email))
    }
}
