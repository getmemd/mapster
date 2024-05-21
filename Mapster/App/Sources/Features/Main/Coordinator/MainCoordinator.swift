//
//  MainCoordinator.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 26.02.2024.
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
    
    private func showAdvertisement(advertisement: Advertisement) {
        let module = moduleFactory.makeAdvertisement(delegate: self, advertisement: advertisement)
        router.push(module)
    }
    
    private func showProfileEdit() {
        let module = moduleFactory.makeProfileEdit(delegate: self)
        router.push(module)
    }
}

// MARK: - HomeNavigationDelegate

extension MainCoordinator: HomeNavigationDelegate {
    func didTapAdvertisement(_ viewController: HomeViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
}

// MARK: - FavouritesNavigationDelegate

extension MainCoordinator: FavouritesNavigationDelegate {
    func didTapAdvertisement(_ viewController: FavouritesViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
}

// MARK: - SearchNavigationDelegate

extension MainCoordinator: SearchNavigationDelegate {
    func didTapAdvertisement(_ viewController: SearchViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
}

// MARK: - ProfileNavigationDelegate

extension MainCoordinator: ProfileNavigationDelegate {
    func didTapEdit(_ viewController: ProfileViewController) {
        showProfileEdit()
    }
    
    func didSignOut(_ viewController: ProfileViewController) {
        delegate?.didFinish(self)
    }
}

// MARK: - CreateNavigationDelegate

extension MainCoordinator: CreateNavigationDelegate {
    func didTapMap(_ viewController: CreateViewController) {
        showMap()
    }
    
    func didCreateAdvertisement(_ viewController: CreateViewController) {
        guard let container = router.navigationController.viewControllers
            .compactMap({ $0 as? ContainerController }).first,
              let viewControllers = container.viewControllers?
            .compactMap({ $0 as? Updatable }) else { return }
        viewControllers.forEach { $0.refreshData() }
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


// MARK: - AdvertisementNavigationDelegate

extension MainCoordinator: AdvertisementNavigationDelegate {
    
}

// MARK: - ProfileEditNavigationDelegate

extension MainCoordinator: ProfileEditNavigationDelegate {
    func didFinish(_ viewController: ProfileEditViewController) {
        router.popModule()
    }
}
