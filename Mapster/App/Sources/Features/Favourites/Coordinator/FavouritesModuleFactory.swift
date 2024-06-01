import Foundation

// Финальный класс для фабрики модулей избранного
final class FavouritesModuleFactory {
    // Создание контроллера списка объявлений
    func makeAdvertisementsList(delegate: AdvertisementsListNavigationDelegate) -> AdvertisementsListViewController {
        let viewController = AdvertisementsListViewController(store: .init(viewState: .favourites))
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    // Создание контроллера объявления
    func makeAdvertisement(delegate: AdvertisementNavigationDelegate, advertisement: Advertisement) -> AdvertisementViewController {
        let viewController = AdvertisementViewController(store: .init(advertisement: advertisement))
        viewController.navigationDelegate = delegate
        return viewController
    }
}
