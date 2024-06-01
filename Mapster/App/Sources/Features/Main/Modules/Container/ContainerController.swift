import UIKit

// Контроллер-контейнер, который является UITabBarController
final class ContainerController: UITabBarController {
    // Инициализация с набором viewControllers
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }

    // Инициализация через NSCoder недоступна
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // Настройка после загрузки представления
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // Настройка внешнего вида таббара
    private func setup() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .accent
    }
}
