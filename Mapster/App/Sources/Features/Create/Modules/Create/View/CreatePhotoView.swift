import UIKit

// Протокол делегата для представления фото
protocol CreatePhotoViewDelegate: AnyObject {
    func didTapDelete(_ view: CreatePhotoView)
}

// Финальный класс для представления фото
final class CreatePhotoView: UIView {
    weak var delegate: CreatePhotoViewDelegate?
    
    // Вид для кнопки удаления
    private lazy var deleteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapDelete))
        imageView.addGestureRecognizer(gesture)
        imageView.tintColor = .gray
        return imageView
    }()
    
    // Изображение
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
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
    
    // Конфигурация представления с изображением
    func configure(image: UIImage) {
        imageView.image = image
    }
    
    // Обработка нажатия на кнопку удаления
    @objc
    private func didTapDelete() {
        delegate?.didTapDelete(self)
    }
    
    // Настройка видов
    private func setupViews() {
        [imageView, deleteImageView].forEach { addSubview($0) }
    }
    
    // Настройка ограничений для видов
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(150)
        }
        deleteImageView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(16)
        }
    }
}
