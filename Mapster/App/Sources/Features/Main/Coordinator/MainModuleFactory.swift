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
    
    func makeSearch(delegate: SearchNavigationDelegate) -> SearchViewController {
        let viewController = SearchViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeFavourites(delegate: FavouritesNavigationDelegate) -> FavouritesViewController {
        let viewController = FavouritesViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeProfile(delegate: ProfileNavigationDelegate) -> ProfileViewController {
        let viewController = ProfileViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeCreate(delegate: CreateNavigationDelegate) -> CreateViewController {
        let viewController = CreateViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeMap(delegate: MapNavigationDelegate) -> MapViewController {
        let viewController = MapViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
