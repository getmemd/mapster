import UIKit

// Финальный класс для контейнера ProgressHud
final class ProgressHudContainerView: UIView {
    // Внутренний вид для фона
    private var backgroundView = UIView()
    // Индикатор активности
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    // Инициализация
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    // Инициализация из storyboard или xib не поддерживается
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Запуск анимации индикатора
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    // Остановка анимации индикатора
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    // Настройка видов
    private func setupViews() {
        addSubview(backgroundView)
        backgroundView.addSubview(activityIndicator)
        backgroundView.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.078, alpha: 0.64)
    }
    
    // Настройка ограничений для видов
    private func setupConstraints() {
        // Ограничения для индикатора активности
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(48)
        }
        // Ограничения для фона
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
