//
//  MainModuleFactory.swift
//  Mapster
//
//  Created by User on 26.02.2024.
//

import UIKit

final class MainModuleFactory {
    // Создание модуля таббар
    func makeTabBar(viewControllers: [UIViewController]) -> ContainerController {
        let containerController = ContainerController(viewControllers: viewControllers)
        return containerController
    }
    
    // Создание домашнего модуля
    func makeHome(delegate: HomeNavigationDelegate) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
