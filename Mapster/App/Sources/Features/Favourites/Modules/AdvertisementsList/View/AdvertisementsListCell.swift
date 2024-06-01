import Kingfisher
import UIKit

// Ячейка для отображения объявлений
final class AdvertisementsListCell: UITableViewCell {
    // Фоновое представление для содержимого ячейки
    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    // Изображение для объявления
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Заголовок объявления
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .semiBold, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    // Цена объявления
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .bold, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // Описание объявления
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .regular, size: 12)
        label.numberOfLines = 0
        return label
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
    
    // Настройка ячейки с моделью данных
    func configure(with cellModel: AdvertisementsListCellModel) {
        titleLabel.text = cellModel.title
        priceLabel.text = cellModel.priceFormatted
        descriptionLabel.text = cellModel.description
        itemImageView.kf.setImage(with: cellModel.imageUrl)
    }
    
    // Настройка представлений ячейки
    private func setupViews() {
        backgroundColor = .clear
        [itemImageView, titleLabel, priceLabel, descriptionLabel].forEach {
            contentBackgroundView.addSubview($0)
        }
        contentView.addSubview(contentBackgroundView)
    }

    // Установка ограничений для представлений ячейки
    private func setupConstraints() {
        contentBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(5)
        }
        itemImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(14)
            $0.width.equalTo(110)
            $0.height.equalTo(130)
        }
        titleLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(14)
            $0.leading.equalTo(itemImageView.snp.trailing).offset(10)
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(14)
            $0.leading.equalTo(itemImageView.snp.trailing).offset(10)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(14)
            $0.bottom.lessThanOrEqualToSuperview().inset(14)
            $0.leading.equalTo(itemImageView.snp.trailing).offset(10)
        }
    }
}
