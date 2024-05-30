import UIKit

// Финальный класс для управления навигацией
final class Router {
    // Навигационный контроллер
    public let navigationController: UINavigationController

    // Инициализация с навигационным контроллером
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // Презентация viewController
    public func present(_ viewController: UIViewController, animated: Bool = true) {
        present(viewController, animated: animated, modalPresentationStyle: .automatic)
    }

    // Презентация viewController с дополнительными параметрами
    public func present(_ viewController: UIViewController,
                        ignorePresented: Bool = false,
                        animated: Bool,
                        modalPresentationStyle: UIModalPresentationStyle) {
        DispatchQueue.main.async { [weak self] in
            viewController.modalPresentationStyle = modalPresentationStyle
            var source: UIViewController? = self?.navigationController
            if !ignorePresented {
                while source?.presentedViewController != nil {
                    source = source?.presentedViewController
                }
            }
            source?.present(viewController, animated: animated)
        }
    }

    // Закрытие текущего модуля
    public func dismissModule(ignorePresented: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            var source: UIViewController? = self?.navigationController
            if !ignorePresented {
                while source?.presentedViewController != nil {
                    source = source?.presentedViewController
                }
            }
            source?.dismiss(animated: animated, completion: completion)
        }
    }

    // Возврат к определенному модулю
    public func popToModule(_ viewController: UIViewController, animated: Bool = true, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popToViewController(viewController, animated: animated)
            completion()
        }
    }

    // Возврат к модулю по типу
    public func popToViewController<T>(type: T.Type, animated: Bool = true, completion: @escaping () -> Void = {}) {
        guard let viewController = navigationController.viewControllers.first(where: { $0 is T }) else { return }
        popToModule(viewController, animated: animated, completion: completion)
    }

    // Переход к новому модулю
    public func push(_ viewController: UIViewController, animated: Bool = true, hideBottomBarWhenPushed: Bool = true) {
        guard viewController is UINavigationController == false else {
            assertionFailure("Deprecated push UINavigationController")
            return
        }
        viewController.hidesBottomBarWhenPushed = hideBottomBarWhenPushed
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.pushViewController(viewController, animated: animated)
        }
    }

    // Возврат к предыдущему модулю
    public func popModule(animated: Bool = true, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popViewController(animated: animated)
            completion()
        }
    }

    // Установка корневого модуля
    public func setRootModule(_ viewController: UIViewController, isNavigationBarHidden: Bool = false) {
        navigationController.setViewControllers([viewController], animated: false)
        navigationController.isNavigationBarHidden = isNavigationBarHidden
    }

    // Возврат к корневому модулю
    public func popToRootModule(animated: Bool = true, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popToRootViewController(animated: animated)
            completion()
        }
    }
}
