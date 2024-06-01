import UIKit

// Протокол делегата для ячейки текстового вида
protocol CreateTextViewCellDelegate: AnyObject {
    func didEndEditing(_ cell: CreateTextViewCell, text: String?)
}

// Финальный класс для ячейки текстового вида
final class CreateTextViewCell: UITableViewCell {
    weak var delegate: CreateTextViewCellDelegate?
    
    // Метка для заголовка
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .semiBold, size: 16)
        label.text = "Описание*"
        return label
    }()
    
    // Текстовый вид
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.font = Font.mulish(name: .regular, size: 14)
        textView.backgroundColor = .textField
        textView.layer.cornerRadius = 10
        textView.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        textView.text = "Расскажите о продукте..."
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    // Метка для счетчика символов
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .regular, size: 14)
        label.text = "0/9000"
        return label
    }()
    
    // Инициализация ячейки
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    // Инициализация из storyboard или xib не поддерживается
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Конфигурация ячейки с текстом
    func configure(text: String?) {
        textView.text = text
    }
    
    // Настройка видов
    private func setupViews() {
        backgroundColor = .clear
        [titleLabel, textView, counterLabel].forEach { contentView.addSubview($0) }
    }
    
    // Настройка ограничений для видов
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        textView.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        counterLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
}

// MARK: - UITextViewDelegate

// Расширение для обработки делегата текстового вида
extension CreateTextViewCell: UITextViewDelegate {
    // Обработка изменения текста
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            counterLabel.text = "0/9000"
        } else {
            let count = textView.text.count
            counterLabel.text = "\(count)/9000"
        }
    }
    
    // Проверка возможности начала редактирования
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return textView.text.count < 9000
    }
    
    // Обработка завершения редактирования
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Расскажите о продукте..."
            textView.textColor = UIColor.lightGray
        }
        delegate?.didEndEditing(self, text: textView.text)
    }
    
    // Обработка начала редактирования
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
