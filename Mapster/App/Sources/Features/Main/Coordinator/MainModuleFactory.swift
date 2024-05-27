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
    
    func makeSearch(delegate: SearchNavigationDelegate,
                    viewState: SearchViewState,
                    category: AdvertisementCategory?) -> SearchViewController {
        let viewController = SearchViewController(store: SearchStore(viewState: viewState, selectedCategory: category))
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeAdvertisementsList(viewState: AdvertisementsListViewState,
                                delegate: AdvertisementsListNavigationDelegate) -> AdvertisementsListViewController {
        let viewController = AdvertisementsListViewController(store: .init(viewState: viewState))
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
    
    func makeAdvertisement(delegate: AdvertisementNavigationDelegate,
                           advertisement: Advertisement) -> AdvertisementViewController {
        let viewController = AdvertisementViewController(store: .init(advertisement: advertisement))
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeProfileEdit(delegate: ProfileEditNavigationDelegate) -> ProfileEditViewController {
        let viewController = ProfileEditViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
