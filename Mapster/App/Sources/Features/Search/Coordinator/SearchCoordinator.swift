import Foundation

final class SearchCoordinator: Coordinator {
    private let moduleFactory = SearchModuleFactory()
    
    override func start() {
        showSearchCategory()
    }
    
    private func showSearchCategory() {
        let module = moduleFactory.makeSearch(delegate: self, viewState: .category, category: nil)
        router.setRootModule(module)
    }
    
    private func showSearchAdvertisements(category: AdvertisementCategory) {
        let module = moduleFactory.makeSearch(delegate: self, viewState: .advertisements, category: category)
        router.push(module)
    }
    
    private func showAdvertisement(advertisement: Advertisement) {
        let module = moduleFactory.makeAdvertisement(delegate: self, advertisement: advertisement)
        router.push(module)
    }
}

// MARK: - SearchNavigationDelegate

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
