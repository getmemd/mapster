import UIKit

// Протокол делегата для ячейки выпадающего списка
protocol CreateDropDownCellDelegate: AnyObject {
    func didSelectCategory(_ cell: CreateDropDownCell, category: AdvertisementCategory)
}

// Финальный класс для ячейки выпадающего списка
final class CreateDropDownCell: UITableViewCell {
    weak var delegate: CreateDropDownCellDelegate?
    
    // Метка для заголовка
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .semiBold, size: 16)
        return label
    }()
    
    // Текстовое поле с выпадающим списком
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .textField
        textField.font = Font.mulish(name: .light, size: 14)
        textField.addPaddingAndIcon(.init(systemName: "chevron.down"), padding: 20, isLeftView: false)
        textField.isUserInteractionEnabled = true
        textField.inputView = pickerView
        return textField
    }()
    
    // Выпадающий список (UIPickerView)
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
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
    
    // Обработка нажатия на текстовое поле
    @objc private func textFieldTapped() {
        textField.becomeFirstResponder()
    }
    
    // Настройка видов
    private func setupViews() {
        backgroundColor = .clear
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textFieldTapped)))
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

// MARK: - UIPickerView DataSource and Delegate

// Расширение для соответствия протоколам UIPickerViewDataSource и UIPickerViewDelegate
extension CreateDropDownCell: UIPickerViewDataSource, UIPickerViewDelegate {
    // Количество компонентов в UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Количество строк в компоненте UIPickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AdvertisementCategory.allCases.count
    }
    
    // Название для строки в компоненте UIPickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AdvertisementCategory.allCases[row].displayName
    }
    
    // Обработка выбора строки в UIPickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = AdvertisementCategory.allCases[row]
        textField.text = category.displayName
        delegate?.didSelectCategory(self, category: category)
    }
}
