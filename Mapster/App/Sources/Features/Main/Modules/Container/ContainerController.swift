import UIKit

final class ContainerController: UITabBarController {
    // Контейнер для таббара
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .accent
    }
}
