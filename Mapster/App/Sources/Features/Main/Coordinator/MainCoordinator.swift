import UIKit

// Протокол делегата для MainCoordinator
protocol MainCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: MainCoordinator)
}

// Главный координатор для управления потоками
final class MainCoordinator: Coordinator {
    private weak var delegate: MainCoordinatorDelegate?
    private let coordinatorFactory = MainCoordinatorFactory()
    private let moduleFactory = MainModuleFactory()
    
    // Инициализация с роутером и делегатом
    init(router: Router, delegate: MainCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    // Запуск основного потока
    override func start() {
        showMain()
    }
    
    // Обновление данных во всех Updatable контроллерах
    private func updateData() {
        guard let container = router.navigationController.viewControllers
            .compactMap({ $0 as? ContainerController }).first,
              let navigationControllers = container.viewControllers?
            .compactMap({ $0 as? UINavigationController }) else { return }
        let updatableControllers = navigationControllers.flatMap { $0.viewControllers.compactMap { $0 as? Updatable } }
        updatableControllers.forEach { $0.refreshData() }
    }
    
    // Отображение главного экрана
    private func showMain() {
        let main = moduleFactory.makeMain(viewControllers: [
            runHomeFlow(),
            runSearchFlow(),
            runCreateFlow(),
            runFavouritesFlow(),
            runProfileFlow()
        ])
        router.setRootModule(main, isNavigationBarHidden: true)
    }
    
    // Запуск потока Home
    private func runHomeFlow() -> UIViewController {
        let (coordinator, module) = coordinatorFactory.makeHome()
        coordinator.start()
        addDependency(coordinator)
        return module
    }
    
    // Запуск потока Search
    private func runSearchFlow() -> UIViewController {
        let (coordinator, module) = coordinatorFactory.makeSearch()
        coordinator.start()
        addDependency(coordinator)
        return module
    }
    
    // Запуск потока Create
    private func runCreateFlow() -> UIViewController {
        let (coordinator, module) = coordinatorFactory.makeCreate(delegate: self)
        coordinator.start()
        addDependency(coordinator)
        return module
    }
    
    // Запуск потока Favourites
    private func runFavouritesFlow() -> UIViewController {
        let (coordinator, module) = coordinatorFactory.makeFavourites(delegate: self)
        coordinator.start()
        addDependency(coordinator)
        return module
    }
    
    // Запуск потока Profile
    private func runProfileFlow() -> UIViewController {
        let (coordinator, module) = coordinatorFactory.makeProfile(delegate: self)
        coordinator.start()
        addDependency(coordinator)
        return module
    }
}

// Обработка событий из CreateCoordinator
extension MainCoordinator: CreateCoordinatorDelegate {
    func needsUpdate(_ coordinator: CreateCoordinator) {
        updateData()
    }
}

// Обработка событий из FavouritesCoordinator
extension MainCoordinator: FavouritesCoordinatorDelegate {
    func needsUpdate(_ coordinator: FavouritesCoordinator) {
        updateData()
    }
}

// Обработка событий из ProfileCoordinator
extension MainCoordinator: ProfileCoordinatorDelegate {
    func didFinish(_ coordinator: ProfileCoordinator) {
        removeDependency(coordinator)
        delegate?.didFinish(self)
    }
    
    func needsUpdate(_ coordinator: ProfileCoordinator) {
        updateData()
    }
}
