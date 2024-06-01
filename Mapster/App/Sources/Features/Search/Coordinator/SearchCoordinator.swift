import Foundation

// Координатор для управления поисковым процессом
final class SearchCoordinator: Coordinator {
    private let moduleFactory = SearchModuleFactory()
    
    // Запуск процесса поиска
    override func start() {
        showSearchCategory()
    }
    
    // Отображение экрана категорий поиска
    private func showSearchCategory() {
        let module = moduleFactory.makeSearch(delegate: self, viewState: .category, category: nil)
        router.setRootModule(module)
    }
    
    // Отображение экрана объявлений для выбранной категории
    private func showSearchAdvertisements(category: AdvertisementCategory) {
        let module = moduleFactory.makeSearch(delegate: self, viewState: .advertisements, category: category)
        router.push(module)
    }
    
    // Отображение экрана конкретного объявления
    private func showAdvertisement(advertisement: Advertisement) {
        let module = moduleFactory.makeAdvertisement(delegate: self, advertisement: advertisement)
        router.push(module)
    }
}

// MARK: - SearchNavigationDelegate

// Расширение для обработки навигации в поиске
extension SearchCoordinator: SearchNavigationDelegate {
    func didTapCategory(_ viewController: SearchViewController, category: AdvertisementCategory) {
        showSearchAdvertisements(category: category)
    }
    
    func didTapAdvertisement(_ viewController: SearchViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
}

// MARK: - AdvertisementNavigationDelegate

extension SearchCoordinator: AdvertisementNavigationDelegate {
    
}
