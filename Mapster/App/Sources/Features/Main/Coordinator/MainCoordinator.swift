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
        let searchModule = moduleFactory.makeSearch(delegate: self, viewState: .category, category: nil)
        searchModule.tabBarItem = .init(title: "Поиск", image: .init(named: "search"), tag: 1)
        let createModule = moduleFactory.makeCreate(delegate: self)
        createModule.tabBarItem = .init(title: "Создать", image: .init(named: "create"), tag: 2)
        let favouriteModule = moduleFactory.makeAdvertisementsList(viewState: .favourites, delegate: self)
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
    
    private func showMyAdvertisements() {
        let module = moduleFactory.makeAdvertisementsList(viewState: .myAdvertisements, delegate: self)
        router.push(module)
    }
    
    private func showSearch(category: AdvertisementCategory) {
        let module = moduleFactory.makeSearch(delegate: self, viewState: .advertisements, category: category)
        router.push(module)
    }
    
    private func updateData() {
        guard let container = router.navigationController.viewControllers
            .compactMap({ $0 as? ContainerController }).first,
              let viewControllers = container.viewControllers?
            .compactMap({ $0 as? Updatable }) else { return }
        viewControllers.forEach { $0.refreshData() }
    }
}

// MARK: - HomeNavigationDelegate

extension MainCoordinator: HomeNavigationDelegate {
    func didTapAdvertisement(_ viewController: HomeViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
}

// MARK: - AdvertisementsListNavigationDelegate

extension MainCoordinator: AdvertisementsListNavigationDelegate {
    func didTapAdvertisement(_ viewController: AdvertisementsListViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
    
    func didDeleteAdvertisement(_ viewController: AdvertisementsListViewController) {
        updateData()
    }
}

// MARK: - SearchNavigationDelegate

extension MainCoordinator: SearchNavigationDelegate {
    func didTapCategory(_ viewController: SearchViewController, category: AdvertisementCategory) {
        showSearch(category: category)
    }
    
    func didTapAdvertisement(_ viewController: SearchViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
}

// MARK: - ProfileNavigationDelegate

extension MainCoordinator: ProfileNavigationDelegate {
    func didTapRow(_ viewController: ProfileViewController, row: ProfileRows) {
        switch row {
        case .editProfile:
            showProfileEdit()
        case .myAdvertisements:
            showMyAdvertisements()
        default:
            return
        }
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
        updateData()
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
