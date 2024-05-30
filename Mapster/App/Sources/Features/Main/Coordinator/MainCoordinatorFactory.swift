import UIKit

final class MainCoordinatorFactory {
    func makeHome() -> (coordinator: Coordinator, module: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "Главная"
        navigationController.tabBarItem.image = .init(named: "home")
        let coordinator = HomeCoordinator(router: Router(navigationController: navigationController))
        return (coordinator, navigationController)
    }
    
    func makeSearch() -> (coordinator: Coordinator, module: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "Поиск"
        navigationController.tabBarItem.image = .init(named: "search")
        let coordinator = SearchCoordinator(router: Router(navigationController: navigationController))
        return (coordinator, navigationController)
    }
    
    func makeCreate(delegate: CreateCoordinatorDelegate) -> (coordinator: Coordinator, module: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "Создать"
        navigationController.tabBarItem.image = .init(named: "create")
        let coordinator = CreateCoordinator(router: Router(navigationController: navigationController),
                                            delegate: delegate)
        return (coordinator, navigationController)
    }
    
    func makeFavourites(delegate: FavouritesCoordinatorDelegate) -> (coordinator: Coordinator, module: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "Избранные"
        navigationController.tabBarItem.image = .init(named: "bookmark")
        let coordinator = FavouritesCoordinator(router: Router(navigationController: navigationController),
                                                delegate: delegate)
        return (coordinator, navigationController)
    }
    
    func makeProfile(delegate: ProfileCoordinatorDelegate) -> (coordinator: Coordinator, module: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = "Профиль"
        navigationController.tabBarItem.image = .init(named: "profile")
        let coordinator = ProfileCoordinator(router: Router(navigationController: navigationController),
                                             delegate: delegate)
        return (coordinator, navigationController)
    }
}
