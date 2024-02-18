//
//  Router.swift
//  Mapster
//
//  Created by Адиль Медеуев on 15.02.2024.
//

import UIKit

final class Router {
    public let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {
        present(viewController, animated: animated, modalPresentationStyle: .automatic)
    }

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

    public func popToModule(_ viewController: UIViewController, animated: Bool = true, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popToViewController(viewController, animated: animated)
            completion()
        }
    }

    public func popToViewController<T>(type: T.Type, animated: Bool = true, completion: @escaping () -> Void = {}) {
        guard let viewController = navigationController.viewControllers.first(where: { $0 is T }) else { return }
        popToModule(viewController, animated: animated, completion: completion)
    }

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

    public func popModule(animated: Bool = true, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popViewController(animated: animated)
            completion()
        }
    }

    public func setRootModule(_ viewController: UIViewController, isNavigationBarHidden: Bool = false) {
        navigationController.setViewControllers([viewController], animated: false)
        navigationController.isNavigationBarHidden = isNavigationBarHidden
    }

    public func popToRootModule(animated: Bool = true, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popToRootViewController(animated: animated)
            completion()
        }
    }
}
