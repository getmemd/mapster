import UIKit

// Фабрика для создания координаторов и модулей
final class MainCoordinatorFactory {
    // Создание координатора и модуля для Home
    func makeHome() -> (coordinator: Coordinator, module: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "Главная"
        navigationController.tabBarItem.image = .init(named: "home")
        let coordinator = HomeCoordinator(router: Router(navigationController: navigationController))
        return (coordinator, navigationController)
    }
    
    // Создание координатора и модуля для Search
    func makeSearch() -> (coordinator: Coordinator, module: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "Поиск"
        navigationController.tabBarItem.image = .init(named: "search")
        let coordinator = SearchCoordinator(router: Router(navigationController: navigationController))
        return (coordinator, navigationController)
    }
    
    // Создание координатора и модуля для Create
    func makeCreate(delegate: CreateCoordinatorDelegate) -> (coordinator: Coordinator, module: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "Создать"
        navigationController.tabBarItem.image = .init(named: "create")
        let coordinator = CreateCoordinator(router: Router(navigationController: navigationController),
                                            delegate: delegate)
        return (coordinator, navigationController)
    }
    
    // Создание координатора и модуля для Favourites
    func makeFavourites(delegate: FavouritesCoordinatorDelegate) -> (coordinator: Coordinator, module: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "Избранные"
        navigationController.tabBarItem.image = .init(named: "bookmark")
        let coordinator = FavouritesCoordinator(router: Router(navigationController: navigationController),
                                                delegate: delegate)
        return (coordinator, navigationController)
    }
    
    // Создание координатора и модуля для Profile
    func makeProfile(delegate: ProfileCoordinatorDelegate) -> (coordinator: Coordinator, module: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "Профиль"
        navigationController.tabBarItem.image = .init(named: "profile")
        let coordinator = ProfileCoordinator(router: Router(navigationController: navigationController),
                                             delegate: delegate)
        return (coordinator, navigationController)
    }
}
