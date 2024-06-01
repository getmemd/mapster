import MapKit

// Протокол делегата для обработки нажатий на кнопку в HomeAnnotationView
protocol HomeAnnotationViewDelegate: AnyObject {
    func didTapCalloutButton(_ view: HomeAnnotationView)
}

// Кастомный вид аннотации для карты
final class HomeAnnotationView: MKAnnotationView {
    weak var delegate: HomeAnnotationViewDelegate?
    
    // Настройка аннотации при изменении
    override var annotation: MKAnnotation? {
        didSet {
            configure(for: annotation)
        }
    }
    
    // Инициализация с аннотацией и идентификатором повторного использования
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure(for: annotation)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Круглый вид для иконки аннотации
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        view.layer.cornerRadius = 18
        return view
    }()
    
    // Иконка внутри круга
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Обработка нажатия на кнопку в аннотации
    @objc
    private func didTapCalloutButton() {
        delegate?.didTapCalloutButton(self)
    }
    
    // Настройка вида для аннотации
    private func configure(for annotation: MKAnnotation?) {
        iconView.image = (annotation as? HomePointAnnotation)?.pinIcon
    }
    
    // Настройка кнопки в аннотации
    private func setupCalloutButton() {
        let button = UIButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(didTapCalloutButton), for: .touchUpInside)
        rightCalloutAccessoryView = button
    }
    
    // Настройка представлений
    private func setupView() {
        canShowCallout = true
        addSubview(circleView)
        circleView.addSubview(iconView)
        setupCalloutButton()
    }
    
    // Настройка ограничений для представлений
    private func setupConstraints() {
        circleView.snp.makeConstraints {
            $0.size.equalTo(36)
            $0.center.equalToSuperview()
        }
        iconView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.center.equalToSuperview()
        }
    }
}
