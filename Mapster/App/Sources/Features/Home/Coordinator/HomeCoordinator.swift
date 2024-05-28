//
//  HomeCoordinator.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 28.05.2024.
//

import Foundation

final class HomeCoordinator: Coordinator {
    private let moduleFactory = HomeModuleFactory()
    
    override func start() {
        showHome()
    }
    
    private func showHome() {
        let module = moduleFactory.makeHome(delegate: self)
        router.setRootModule(module)
    }
    
    private func showAdvertisement(advertisement: Advertisement) {
        let module = moduleFactory.makeAdvertisement(delegate: self, advertisement: advertisement)
        router.push(module)
    }
}

// MARK: - HomeNavigationDelegate

extension HomeCoordinator: HomeNavigationDelegate {
    func didTapAdvertisement(_ viewController: HomeViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
}

// MARK: - AdvertisementNavigationDelegate

extension HomeCoordinator: AdvertisementNavigationDelegate {
    
}
