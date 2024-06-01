import Foundation

// Класс координатора для главного экрана
final class HomeCoordinator: Coordinator {
    // Фабрика модулей для создания экранов
    private let moduleFactory = HomeModuleFactory()
    
    // Метод для запуска координатора
    override func start() {
        showHome()
    }
    
    // Показать главный экран
    private func showHome() {
        // Создание и установка корневого модуля
        let module = moduleFactory.makeHome(delegate: self)
        router.setRootModule(module)
    }
    
    // Показать экран объявления
    private func showAdvertisement(advertisement: Advertisement) {
        // Создание и переход к экрану объявления
        let module = moduleFactory.makeAdvertisement(delegate: self, advertisement: advertisement)
        router.push(module)
    }
}

// MARK: - HomeNavigationDelegate

// Расширение для обработки навигации на главном экране
extension HomeCoordinator: HomeNavigationDelegate {
    // Обработка нажатия на объявление
    func didTapAdvertisement(_ viewController: HomeViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
}

// MARK: - AdvertisementNavigationDelegate

// Расширение для обработки навигации на экране объявления
extension HomeCoordinator: AdvertisementNavigationDelegate {
    
}
