import Foundation

// Фабрика для создания модулей профиля
final class ProfileModuleFactory {
    // Создание и настройка контроллера профиля
    func makeProfile(delegate: ProfileNavigationDelegate) -> ProfileViewController {
        let viewController = ProfileViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    // Создание и настройка контроллера редактирования профиля
    func makeProfileEdit(delegate: ProfileEditNavigationDelegate) -> ProfileEditViewController {
        let viewController = ProfileEditViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    // Создание и настройка контроллера списка объявлений
    func makeAdvertisementsList(delegate: AdvertisementsListNavigationDelegate) -> AdvertisementsListViewController {
        let viewController = AdvertisementsListViewController(store: .init(viewState: .myAdvertisements))
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
    
    // Создание и настройка контроллера для отображения политики конфиденциальности
    func makePolicy(delegate: InfoNavigationDelegate) -> InfoViewController {
        let viewController = InfoViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
