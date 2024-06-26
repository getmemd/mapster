//
//  FavourtiesModuleFactory.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 28.05.2024.
//

import Foundation

final class FavouritesModuleFactory {
    func makeAdvertisementsList(delegate: AdvertisementsListNavigationDelegate) -> AdvertisementsListViewController {
        let viewController = AdvertisementsListViewController(store: .init(viewState: .favourites))
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
