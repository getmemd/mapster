//
//  Router.swift
//  Mapster
//
//  Created by User on 15.02.2024.
//

import UIKit

final class Router {
    public let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // Метод для отображения модального контроллера
    public func present(_ viewController: UIViewController, animated: Bool = true) {
        // Делегируем вызов другому методу с аргументом modalPresentationStyle по умолчанию
        present(viewController, animated: animated, modalPresentationStyle: .automatic)
    }

    // Метод для отображения модального контроллера с дополнительными параметрами
    public func present(_ viewController: UIViewController,
                        ignorePresented: Bool = false,
                        animated: Bool,
                        modalPresentationStyle: UIModalPresentationStyle) {
        // Асинхронно отображаем контроллер, учитывая параметры
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

    // Метод для закрытия модального контроллера
    public func dismissModule(ignorePresented: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        // Асинхронно закрываем модальный контроллер, учитывая параметры
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

    // Метод для возврата к указанному контроллеру в стеке навигации
    public func popToModule(_ viewController: UIViewController, animated: Bool = true, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popToViewController(viewController, animated: animated)
            completion()
        }
    }

    // Метод для возврата к контроллеру определенного типа в стеке навигации
    public func popToViewController<T>(type: T.Type, animated: Bool = true, completion: @escaping () -> Void = {}) {
        guard let viewController = navigationController.viewControllers.first(where: { $0 is T }) else { return }
        popToModule(viewController, animated: animated, completion: completion)
    }

    // Метод для добавления контроллера в стек навигации
    public func push(_ viewController: UIViewController, animated: Bool = true, hideBottomBarWhenPushed: Bool = true) {
        // Предотвращаем добавление UINavigationController в UINavigationController
        guard viewController is UINavigationController == false else {
            assertionFailure("Deprecated push UINavigationController")
            return
        }
        viewController.hidesBottomBarWhenPushed = hideBottomBarWhenPushed
        // Асинхронно добавляем контроллер в стек навигации
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.pushViewController(viewController, animated: animated)
        }
    }

    // Метод для удаления текущего контроллера из стека навигации
    public func popModule(animated: Bool = true, completion: @escaping () -> Void = {}) {
        // Асинхронно удаляем текущий контроллер из стека навигации
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popViewController(animated: animated)
            completion()
        }
    }

    // Метод для установки корневого контроллера
    public func setRootModule(_ viewController: UIViewController, isNavigationBarHidden: Bool = false) {
        navigationController.setViewControllers([viewController], animated: false)
        navigationController.isNavigationBarHidden = isNavigationBarHidden
    }

    // Метод для возврата к корневому контроллеру
    public func popToRootModule(animated: Bool = true, completion: @escaping () -> Void = {}) {
        // Асинхронно возвращаемся к корневому контроллеру
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popToRootViewController(animated: animated)
            completion()
        }
    }
}

