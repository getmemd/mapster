import UIKit

// Константы для ProgressHud
private enum Constants {
    static let animationDuration: TimeInterval = 0.25
}

// Финальный класс для ProgressHud
final class ProgressHud {
    // Контейнер для ProgressHud
    private static var containerView: ProgressHudContainerView = {
        let containerView = ProgressHudContainerView()
        containerView.alpha = 1.0
        return containerView
    }()
    
    // Запуск анимации
    static func startAnimating() {
        guard let window = UIApplication
            .shared
            .connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .last else { return }
        if !window.subviews.contains(containerView) {
            addContainerView(to: window)
        }
        
        window.endEditing(true)
        UIView.animate(withDuration: Constants.animationDuration,
                       animations: { self.containerView.alpha = 1.0 },
                       completion: { _ in self.containerView.startAnimating() })
    }
    
    // Остановка анимации
    static func stopAnimating() {
        let completion: (Bool) -> Void = { _ in
            self.containerView.removeFromSuperview()
            self.containerView.stopAnimating()
        }
        UIView.animate(withDuration: Constants.animationDuration,
                       animations: { self.containerView.alpha = 0.0 },
                       completion: completion)
    }
    
    // Добавление контейнера на окно
    private static func addContainerView(to window: UIWindow) {
        containerView.frame = CGRect(origin: .zero, size: window.frame.size)
        window.addSubview(containerView)
    }
}
