//
//  FavouritesCoordinator.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 28.05.2024.
//

import Foundation

protocol FavouritesCoordinatorDelegate: AnyObject {
    func needsUpdate(_ coordinator: FavouritesCoordinator)
}

final class FavouritesCoordinator: Coordinator {
    private weak var delegate: FavouritesCoordinatorDelegate?
    private let moduleFactory = FavouritesModuleFactory()
    
    init(router: Router, delegate: FavouritesCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    override func start() {
        showFavourites()
    }
    
    private func showFavourites() {
        let module = moduleFactory.makeAdvertisementsList(delegate: self)
        router.setRootModule(module)
    }
    
    private func showAdvertisement(advertisement: Advertisement) {
        let module = moduleFactory.makeAdvertisement(delegate: self, advertisement: advertisement)
        router.push(module)
    }
}

// MARK: - AdvertisementsListNavigationDelegate

extension FavouritesCoordinator: AdvertisementsListNavigationDelegate {
    func didTapAdvertisement(_ viewController: AdvertisementsListViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
    
    func didDeleteAdvertisement(_ viewController: AdvertisementsListViewController) {
        delegate?.needsUpdate(self)
    }
}

// MARK: - AdvertisementNavigationDelegate

extension FavouritesCoordinator: AdvertisementNavigationDelegate {
    
}
