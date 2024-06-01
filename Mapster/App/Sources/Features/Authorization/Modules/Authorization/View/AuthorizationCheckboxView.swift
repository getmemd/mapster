import SnapKit
import UIKit

// Протокол делегата для представления чекбокса авторизации
protocol AuthorizationCheckboxViewDelegate: AnyObject {
    func didTapForgotPassword(_ view: AuthorizationCheckboxView)
}

// Финальный класс для представления чекбокса авторизации
final class AuthorizationCheckboxView: UIView {
    weak var delegate: AuthorizationCheckboxViewDelegate?
    
    // Свойство для проверки, выбран ли чекбокс
    var isSelected: Bool {
        checkBoxButton.isSelected
    }
    
    // Стек для размещения содержимого
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkBoxButton, textView, forgotPasswordLabel])
        stackView.spacing = 4
        return stackView
    }()
    
    // Кнопка чекбокса
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
        button.setImage(UIImage(named: "checkbox_checked"), for: .selected)
        button.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // Текстовое поле с условиями использования
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
    
    // Метка для текста "Забыли пароль?"
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
    
    // Инициализация представления
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    // Инициализация из storyboard или xib не поддерживается
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Конфигурация представления с моделью
    func configure(with viewModel: AuthorizationCheckoxViewModel) {
        textView.isHidden = !viewModel.isRegistration
        checkBoxButton.isHidden = !viewModel.isRegistration
        forgotPasswordLabel.isHidden = viewModel.isRegistration
    }
    
    // Обработка нажатия на метку "Забыли пароль?"
    @objc
    private func forgotPasswordDidTap() {
        delegate?.didTapForgotPassword(self)
    }
    
    // Обработка нажатия на кнопку чекбокса
    @objc
    private func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    // Настройка видов
    private func setupViews() {
        addSubview(contentStackView)
    }
    
    // Настройка ограничений для видов
    private func setupConstraints() {
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        checkBoxButton.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
}
