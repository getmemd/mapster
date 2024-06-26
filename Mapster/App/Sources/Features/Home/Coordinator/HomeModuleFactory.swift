//
//  HomeModuleFactory.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 28.05.2024.
//

import Foundation

final class HomeModuleFactory {
    func makeHome(delegate: HomeNavigationDelegate) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeAdvertisement(delegate: AdvertisementNavigationDelegate,
                           advertisement: Advertisement) -> AdvertisementViewController {
        let viewController = AdvertisementViewController(store: .init(advertisement: advertisement))
        viewController.navigationDelegate = delegate
        return viewController
    }
}
