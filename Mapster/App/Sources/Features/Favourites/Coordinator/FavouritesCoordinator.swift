import Foundation

// Протокол делегата для координатора избранного
protocol FavouritesCoordinatorDelegate: AnyObject {
    func needsUpdate(_ coordinator: FavouritesCoordinator)
}

// Финальный класс для координатора избранного
final class FavouritesCoordinator: Coordinator {
    private weak var delegate: FavouritesCoordinatorDelegate?
    private let moduleFactory = FavouritesModuleFactory()
    
    // Инициализация координатора с роутером и делегатом
    init(router: Router, delegate: FavouritesCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    // Запуск координатора
    override func start() {
        showFavourites()
    }
    
    // Показ модуля избранного
    private func showFavourites() {
        let module = moduleFactory.makeAdvertisementsList(delegate: self)
        router.setRootModule(module)
    }
    
    // Показ модуля объявления
    private func showAdvertisement(advertisement: Advertisement) {
        let module = moduleFactory.makeAdvertisement(delegate: self, advertisement: advertisement)
        router.push(module)
    }
}

// MARK: - AdvertisementsListNavigationDelegate

// Расширение для обработки навигации списка объявлений
extension FavouritesCoordinator: AdvertisementsListNavigationDelegate {
    // Обработка нажатия на объявление
    func didTapAdvertisement(_ viewController: AdvertisementsListViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
    
    // Обработка удаления объявления
    func didDeleteAdvertisement(_ viewController: AdvertisementsListViewController) {
        delegate?.needsUpdate(self)
    }
}

// MARK: - AdvertisementNavigationDelegate

// Расширение для обработки навигации объявления
extension FavouritesCoordinator: AdvertisementNavigationDelegate {
    
}
