import UIKit

// Протокол делегата для ячейки текстового поля
protocol CreateTextFieldCellDelegate: AnyObject {
    func didEndEditing(_ cell: CreateTextFieldCell, text: String?)
}

// Финальный класс для ячейки текстового поля
final class CreateTextFieldCell: UITableViewCell {
    weak var delegate: CreateTextFieldCellDelegate?
    
    // Метка для заголовка
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .semiBold, size: 16)
        return label
    }()
    
    // Текстовое поле
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .textField
        textField.font = Font.mulish(name: .light, size: 14)
        return textField
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
    
    // Конфигурация ячейки с моделью
    func configure(with cellModel: CreateTextFieldCellModel) {
        titleLabel.text = cellModel.title
        textField.placeholder = cellModel.placeholder
        textField.keyboardType = cellModel.keyboardType
        textField.text = cellModel.value
    }
    
    // Настройка видов
    private func setupViews() {
        backgroundColor = .clear
        [titleLabel, textField].forEach { contentView.addSubview($0) }
    }
    
    // Настройка ограничений для видов
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        textField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
}

// MARK: - UITextFieldDelegate

// Расширение для обработки делегата текстового поля
extension CreateTextFieldCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didEndEditing(self, text: textField.text)
    }
}
