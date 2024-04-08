//
//  PasswordResetViewController.swift
//  Mapster
//
//  Created by User on 25.02.2024.
//

import SnapKit
import UIKit

protocol PasswordResetNavigationDelegate: AnyObject {
    func didFinish(_ viewController: PasswordResetViewController)
}

final class PasswordResetViewController: BaseViewController {
    var navigationDelegate: PasswordResetNavigationDelegate?
    private let store = PasswordResetStore()
    private var bag = Bag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новый пароль"
        label.font = Font.mulish(name: .extraBold, size: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Придумайте надежный пароль для своей учетной записи и введите его в оба окна."
        label.font = Font.mulish(name: .light, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    // Текстовое поле пароля
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .textField
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(named: "lock"), padding: 20, isLeftView: false)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // Текстовое поле повтора пароля
    private lazy var repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Повторите пароль"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .textField
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(named: "lock"), padding: 20, isLeftView: false)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // Кнопка подтвердить
    private lazy var actionButton: ActionButton = {
        let button = ActionButton()
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.setTitle("Подтвердить", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // Метод для проверки полей после нажатия подтвердить
    @objc
    private func actionButtonDidTap() {
        guard let password = passwordTextField.text,
              let repeatPassword = repeatPasswordTextField.text else { return }
        do {
            try PasswordValidatationService.checkPasswordValidity(password: password, repeatPassword: repeatPassword)
            store.sendAction(.actionButtonDidTap(password: password))
        } catch let error as PasswordError {
            showPasswordAlert(message: error.failureReason)
        } catch {
            return
        }
        navigationDelegate?.didFinish(self)
    }
    
    // Уведомление об ошибке в пароле
    private func showPasswordAlert(message: String?) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Проверка на данные в паролях
    private func checkValidity() -> Bool {
        !(passwordTextField.text?.isEmpty ?? true) &&
        !(repeatPasswordTextField.text?.isEmpty ?? true)
    }
    
    // Настройка наблюдателей эвентов от стора
    private func configureObservers() {
        bindStore(store) { [weak self ] event in
            guard let self else { return }
            switch event {
            case let .showError(errorMessage):
                showAlert(message: errorMessage)
            case .loading:
                activityIndicator.startAnimating()
            case .loadingFinished:
                activityIndicator.stopAnimating()
            case .passwordUpdated:
                navigationDelegate?.didFinish(self)
            }
        }
        .store(in: &bag)
    }
    
    private func setupViews() {
        [titleLabel, descriptionLabel, passwordTextField, repeatPasswordTextField, actionButton].forEach { view.addSubview($0) }
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        repeatPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        actionButton.snp.makeConstraints {
            $0.top.equalTo(repeatPasswordTextField.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
    }
}

// MARK: - UITextFieldDelegate

extension PasswordResetViewController: UITextFieldDelegate {
    // Вызывается после завершения изменений
    func textFieldDidEndEditing(_ textField: UITextField) {
        actionButton.isEnabled = checkValidity()
    }
}
