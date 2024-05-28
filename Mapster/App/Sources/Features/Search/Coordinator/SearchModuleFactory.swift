//
//  SearchModuleFactory.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 28.05.2024.
//

import Foundation

final class SearchModuleFactory {
    func makeSearch(delegate: SearchNavigationDelegate,
                    viewState: SearchViewState,
                    category: AdvertisementCategory?) -> SearchViewController {
        let viewController = SearchViewController(store: SearchStore(viewState: viewState, selectedCategory: category))
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
