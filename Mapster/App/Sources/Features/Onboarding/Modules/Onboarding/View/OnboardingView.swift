import SnapKit
import UIKit

// Представление для отображения страницы онбординга
final class OnboardingView: UIView {
    private var contentView = UIView()
    
    // Изображение для отображения на странице онбординга
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // Заголовок для страницы онбординга
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .extraBold, size: 36)
        label.numberOfLines = 0
        return label
    }()
    
    // Описание для страницы онбординга
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .light, size: 24)
        label.numberOfLines = 0
        return label
    }()
    
    // Инициализация представления
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Конфигурация представления с использованием viewModel
    func configure(with viewModel: OnboardingViewModel) {
        imageView.image = UIImage(named: viewModel.imageName)
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
    
    // Настройка представлений
    private func setupViews() {
        addSubview(contentView)
        [imageView, titleLabel, descriptionLabel].forEach { contentView.addSubview($0) }
    }
    
    // Настройка ограничений для представлений
    private func setupConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}
