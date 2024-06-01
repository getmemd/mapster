import UIKit

// Протокол делегата для навигации в ProfileEditViewController
protocol ProfileEditNavigationDelegate: AnyObject {
    func didFinish(_ viewController: ProfileEditViewController)
}

// Контроллер для редактирования профиля пользователя
final class ProfileEditViewController: BaseViewController {
    weak var navigationDelegate: ProfileEditNavigationDelegate?
    private lazy var store = ProfileEditStore()
    private var bag = Bag()
    
    // Стек для размещения заголовка и текстовых полей
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, nameTextField, phoneNumberTextField])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    // Заголовок экрана
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Редактировать профиль"
        label.font = Font.mulish(name: .extraBold, size: 24)
        label.numberOfLines = 0
        return label
    }()
    
    // Текстовое поле для имени
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
    
    // Текстовое поле для номера телефона
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
    
    // Кнопка для подтверждения изменений
    private lazy var actionButton: ActionButton = {
        let button = ActionButton()
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.setTitle("Подтвердить", for: .normal)
        return button
    }()
    
    // Настройка представлений после загрузки
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureObservers()
    }
    
    // Обработка нажатия на кнопку подтверждения
    @objc
    private func actionButtonDidTap() {
        guard phoneNumberTextField.text?.isEmpty == true ||
                (!(phoneNumberTextField.text?.isEmpty ?? true) &&
                 ValidationService.checkPhoneNumberValidity(phoneNumber: phoneNumberTextField.text)) else {
            showAlert(message: "Введите правильный номер")
            return
        }
        store.handleAction(.actionButtonDidTap(name: nameTextField.text, phoneNumber: phoneNumberTextField.text))
    }
    
    // Настройка наблюдателей для обработки событий из store
    private func configureObservers() {
        bindStore(store) { [weak self] event in
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
    
    // Настройка всех представлений
    private func setupViews() {
        [contentStackView, actionButton].forEach { view.addSubview($0) }
        view.backgroundColor = .white
    }
    
    // Настройка ограничений для представлений
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

// Расширение для обработки событий UITextFieldDelegate
extension ProfileEditViewController: UITextFieldDelegate {
    
    // Форматирование номера телефона
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
    
    // Обработка изменения текста в текстовом поле
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard textField == phoneNumberTextField else { return true }
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
}
