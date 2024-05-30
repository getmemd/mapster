import UIKit

// Финальный класс для ячейки таблицы
final class TableViewItemCell: UITableViewCell {
    // Фоновой вид для содержания
    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    // Стековый вид для размещения иконки, заголовка и стрелки
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, arrowImageView])
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    // Вид для иконки
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Заголовок
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .semiBold, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // Вид для стрелки
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Инициализация ячейки
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Конфигурация ячейки с моделью
    func configure(with cellModel: TableViewItemCellModel) {
        if let iconName = cellModel.iconName {
            iconImageView.image = UIImage(systemName: iconName)
        } else {
            iconImageView.isHidden = cellModel.iconName == nil
        }
        titleLabel.text = cellModel.title
    }
    
    // Настройка видов
    private func setupViews() {
        backgroundColor = .clear
        contentView.addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(stackView)
    }
    
    // Настройка ограничений для видов
    private func setupConstraints() {
        contentBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        arrowImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
}
