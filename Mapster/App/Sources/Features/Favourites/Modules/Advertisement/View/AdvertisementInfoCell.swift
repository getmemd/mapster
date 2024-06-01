import UIKit

// Протокол делегата ячейки информации объявления
protocol AdvertisementInfoCellDelegate: AnyObject {
    func didTapOpenInMap(_ cell: AdvertisementInfoCell, mapType: MapType)
    func didTapCallByPhone(_ cell: AdvertisementInfoCell)
}

// Финальный класс для ячейки информации объявления
final class AdvertisementInfoCell: UITableViewCell {
    weak var delegate: AdvertisementInfoCellDelegate?
    
    // Лейбл для даты
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .regular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    // Лейбл для заголовка
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .semiBold, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // Лейбл для категории
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .regular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    // Лейбл для цены
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .bold, size: 22)
        label.numberOfLines = 0
        return label
    }()
    
    // Лейбл для описания
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = Font.mulish(name: .regular, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // Фон для описания
    private let descriptionBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cellGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    // Лейбл для текста описания
    private let descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .regular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    // Лейбл для контактов
    private let contactLabel: UILabel = {
        let label = UILabel()
        label.text = "Контакты"
        label.font = Font.mulish(name: .regular, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // Фон для контактов
    private lazy var contactBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cellGray
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(callByPhone))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    // Лейбл для имени
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .semiBold, size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    // Лейбл для телефона
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .regular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    // Лейбл для местонахождения
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Местонахождение"
        label.font = Font.mulish(name: .regular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    // Лейбл для адреса
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .regular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    // Кнопка для открытия адреса в 2GIS
    private lazy var doubleGisButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .accent
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Посмотреть адрес в 2GIS", for: .normal)
        button.addTarget(self, action: #selector(doubleGisDidTap), for: .touchUpInside)
        return button
    }()
    
    // Кнопка для открытия адреса в Яндекс.Картах
    private lazy var yandexMapButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Посмотреть в Яндекс.Карты", for: .normal)
        button.addTarget(self, action: #selector(yandexMapDidTap), for: .touchUpInside)
        return button
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
    
    // Обработка нажатия для звонка по телефону
    @objc
    private func callByPhone() {
        delegate?.didTapCallByPhone(self)
    }
    
    // Обработка нажатия для открытия адреса в 2GIS
    @objc
    private func doubleGisDidTap() {
        delegate?.didTapOpenInMap(self, mapType: .doubleGis)
    }
    
    // Обработка нажатия для открытия адреса в Яндекс.Картах
    @objc
    private func yandexMapDidTap() {
        delegate?.didTapOpenInMap(self, mapType: .yandexMap)
    }
    
    // Конфигурация ячейки с моделью данных
    func configure(with cellModel: AdvertisementInfoCellModel) {
        dateLabel.text = cellModel.date
        titleLabel.text = cellModel.title
        categoryLabel.text = cellModel.category
        priceLabel.text = cellModel.price
        descriptionTextLabel.text = cellModel.description
        nameLabel.text = cellModel.personName
        phoneLabel.text = cellModel.phoneNumber
        addressLabel.text = cellModel.address
    }
    
    // Настройка видов
    private func setupViews() {
        backgroundColor = .clear
        descriptionBackgroundView.backgroundColor = UIColor.cellGray
        contactBackgroundView.backgroundColor = UIColor.cellGray
        descriptionBackgroundView.addSubview(descriptionTextLabel)
        [nameLabel, phoneLabel].forEach { contactBackgroundView.addSubview($0) }
        [
            dateLabel,
            titleLabel,
            categoryLabel,
            priceLabel,
            descriptionLabel,
            descriptionBackgroundView,
            contactLabel,
            contactBackgroundView,
            locationLabel,
            addressLabel,
            doubleGisButton,
            yandexMapButton
        ].forEach {
            contentView.addSubview($0)
        }
    }

    // Настройка ограничений для видов
    private func setupConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        descriptionBackgroundView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        descriptionTextLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        contactLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionBackgroundView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        contactBackgroundView.snp.makeConstraints {
            $0.top.equalTo(contactLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        phoneLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(10)
        }
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(contactBackgroundView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        doubleGisButton.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(24)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        yandexMapButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(doubleGisButton.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
}
