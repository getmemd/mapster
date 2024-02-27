//
//  MainModuleFactory.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 26.02.2024.
//

import UIKit

final class MainModuleFactory {
    func makeTabBar(viewControllers: [UIViewController]) -> ContainerController {
        let containerController = ContainerController(viewControllers: viewControllers)
        return containerController
    }
    
    func makeHome(delegate: HomeNavigationDelegate) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
