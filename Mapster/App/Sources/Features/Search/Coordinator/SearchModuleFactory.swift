import Foundation

// Фабрика для создания модулей поиска
final class SearchModuleFactory {
    // Создание и настройка контроллера поиска
    func makeSearch(delegate: SearchNavigationDelegate,
                    viewState: SearchViewState,
                    category: AdvertisementCategory?) -> SearchViewController {
        let viewController = SearchViewController(store: SearchStore(viewState: viewState, selectedCategory: category))
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    // Создание и настройка контроллера для конкретного объявления
    func makeAdvertisement(delegate: AdvertisementNavigationDelegate,
                           advertisement: Advertisement) -> AdvertisementViewController {
        let viewController = AdvertisementViewController(store: .init(advertisement: advertisement))
        viewController.navigationDelegate = delegate
        return viewController
    }
}
