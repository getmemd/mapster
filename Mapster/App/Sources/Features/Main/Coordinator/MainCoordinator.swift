//
//  MainCoordinator.swift
//  Mapster
//
//  Created by User on 26.02.2024.
//

import Foundation
import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: MainCoordinator)
}

final class MainCoordinator: Coordinator {
    private let delegate: MainCoordinatorDelegate?
    private let moduleFactory = MainModuleFactory()
    
    init(router: Router, delegate: MainCoordinatorDelegate?) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    override func start() {
        showTabBar()
    }
    
    // Создает модули и присваивет их в таббар
    private func showTabBar() {
        let homeModule = moduleFactory.makeHome(delegate: self)
        let searchModule = moduleFactory.makeSearch(delegate: self)
        searchModule.tabBarItem = .init(title: "Поиск", image: .init(named: "search"), tag: 1)
        let createModule = moduleFactory.makeCreate(delegate: self)
        createModule.tabBarItem = .init(title: "Создать", image: .init(named: "create"), tag: 2)
        let favouriteModule = moduleFactory.makeFavourites(delegate: self)
        favouriteModule.tabBarItem = .init(title: "Избранные", image: .init(named: "bookmark"), tag: 3)
        let profileModule = moduleFactory.makeProfile(delegate: self)
        profileModule.tabBarItem = .init(title: "Профиль", image: .init(named: "profile"), tag: 4)
        let module = moduleFactory.makeTabBar(viewControllers: [
            homeModule, searchModule, createModule, favouriteModule, profileModule
        ])
        router.setRootModule(module)
    }
    
    private func showMap() {
        let module = moduleFactory.makeMap(delegate: self)
        router.present(module, animated: true, modalPresentationStyle: .overFullScreen)
    }
}

// MARK: - HomeNavigationDelegate

extension MainCoordinator: HomeNavigationDelegate {
    
}

// MARK: - FavouritesNavigationDelegate

extension MainCoordinator: FavouritesNavigationDelegate {
    
}

// MARK: - SearchNavigationDelegate

extension MainCoordinator: SearchNavigationDelegate {
    
}

// MARK: - ProfileNavigationDelegate

extension MainCoordinator: ProfileNavigationDelegate {
    func didSignOut(_ viewController: ProfileViewController) {
        delegate?.didFinish(self)
    }
}

// MARK: - CreateNavigationDelegate

extension MainCoordinator: CreateNavigationDelegate {
    func didTapMap(_ viewController: CreateViewController) {
        showMap()
    }
}

// MARK: - MapNavigationDelegate

extension MainCoordinator: MapNavigationDelegate {
    func didTapActionButton(_ viewController: MapViewController, latitude: Double, longitude: Double) {
        router.dismissModule { [weak self] in
            guard let container = self?.router.navigationController.viewControllers
                .compactMap({ $0 as? ContainerController }).first,
                  let viewController = container.viewControllers?
                .compactMap({ $0 as? CreateViewController }).first else { return }
            viewController.didPickedLocation(latitude: latitude, longitude: longitude)
        }
    }
}
