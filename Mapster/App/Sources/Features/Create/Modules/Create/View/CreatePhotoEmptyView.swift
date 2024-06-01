import UIKit

// Финальный класс для представления пустого состояния добавления фото
final class CreatePhotoEmptyView: UIView {
    // Фоновой вид для содержимого
    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    // Изображение иконки
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app")
        imageView.tintColor = .black
        return imageView
    }()
    
    // Метка заголовка
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .regular, size: 13)
        label.numberOfLines = 0
        label.text = "Добавить фото"
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
    
    // Настройка видов
    private func setupViews() {
        addSubview(contentBackgroundView)
        [iconImageView, titleLabel].forEach { contentBackgroundView.addSubview($0) }
    }
    
    // Настройка ограничений для видов
    private func setupConstraints() {
        contentBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(150)
        }
        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImageView.snp.bottom).offset(5)
        }
    }
}
