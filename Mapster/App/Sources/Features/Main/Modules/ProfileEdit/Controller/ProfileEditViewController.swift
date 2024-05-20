//
//  ProfileEditViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 20.05.2024.
//

import UIKit

protocol ProfileEditNavigationDelegate: AnyObject {
    func didFinish(_ viewController: ProfileEditViewController)
}

final class ProfileEditViewController: BaseViewController {
    weak var navigationDelegate: ProfileEditNavigationDelegate?
    private lazy var store = ProfileEditStore()
    private var bag = Bag()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, nameTextField, phoneNumberTextField])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Редактировать профиль"
        label.font = Font.mulish(name: .extraBold, size: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Имя"
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
    
    private lazy var actionButton: ActionButton = {
        let button = ActionButton()
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.setTitle("Подтвердить", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureObservers()
    }
    
    @objc
    private func actionButtonDidTap() {
        guard phoneNumberTextField.text?.isEmpty == true ||
                (!(phoneNumberTextField.text?.isEmpty ?? true) &&
                 ValidatationService.checkPhoneNumberValidity(phoneNumber: phoneNumberTextField.text)) else {
            showAlert(message: "Введите правильный номер")
            return
        }
        store.handleAction(.actionButtonDidTap(name: nameTextField.text, phoneNumber: phoneNumberTextField.text))
    }
    
    private func configureObservers() {
        bindStore(store) { [weak self ] event in
            guard let self else { return }
            switch event {
            case let .showError(message):
                showAlert(message: message)
            case .loading:
                ProgressHud.startAnimating()
            case .loadingFinished:
                ProgressHud.stopAnimating()
            case .success:
                navigationDelegate?.didFinish(self)
            }
        }
        .store(in: &bag)
    }
    
    private func setupViews() {
        [contentStackView, actionButton].forEach { view.addSubview($0) }
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        phoneNumberTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        actionButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
}

// MARK: - UITextFieldDelegate

extension ProfileEditViewController: UITextFieldDelegate {
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
