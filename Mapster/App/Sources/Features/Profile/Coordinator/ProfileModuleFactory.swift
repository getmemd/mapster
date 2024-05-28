//
//  ProfileModuleFactory.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 28.05.2024.
//

import Foundation

final class ProfileModuleFactory {
    func makeProfile(delegate: ProfileNavigationDelegate) -> ProfileViewController {
        let viewController = ProfileViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeProfileEdit(delegate: ProfileEditNavigationDelegate) -> ProfileEditViewController {
        let viewController = ProfileEditViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeAdvertisementsList(delegate: AdvertisementsListNavigationDelegate) -> AdvertisementsListViewController {
        let viewController = AdvertisementsListViewController(store: .init(viewState: .myAdvertisements))
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeAdvertisement(delegate: AdvertisementNavigationDelegate,
                           advertisement: Advertisement) -> AdvertisementViewController {
        let viewController = AdvertisementViewController(store: .init(advertisement: advertisement))
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makePolicy(delegate: InfoNavigationDelegate) -> InfoViewController {
        let viewController = InfoViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
