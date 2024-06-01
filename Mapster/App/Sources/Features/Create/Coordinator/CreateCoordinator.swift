import Foundation

// Протокол делегата для координатора создания
protocol CreateCoordinatorDelegate: AnyObject {
    func needsUpdate(_ coordinator: CreateCoordinator)
}

// Финальный класс для координатора создания
final class CreateCoordinator: Coordinator {
    private weak var delegate: CreateCoordinatorDelegate?
    private let moduleFactory = CreateModuleFactory()
    
    // Инициализация с роутером и делегатом
    init(router: Router, delegate: CreateCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    // Запуск координатора
    override func start() {
        showCreate()
    }
    
    // Показ модуля создания
    private func showCreate() {
        let module = moduleFactory.makeCreate(delegate: self)
        router.setRootModule(module)
    }
    
    // Показ модуля карты
    private func showMap() {
        let module = moduleFactory.makeMap(delegate: self)
        router.present(module, animated: true, modalPresentationStyle: .overFullScreen)
    }
}

// MARK: - CreateNavigationDelegate

// Расширение для обработки навигации из модуля создания
extension CreateCoordinator: CreateNavigationDelegate {
    func didTapMap(_ viewController: CreateViewController) {
        showMap()
    }
    
    func didCreateAdvertisement(_ viewController: CreateViewController) {
        delegate?.needsUpdate(self)
    }
}

// MARK: - MapNavigationDelegate

// Расширение для обработки навигации из модуля карты
extension CreateCoordinator: MapNavigationDelegate {
    func didTapActionButton(_ viewController: MapViewController, latitude: Double, longitude: Double) {
        router.dismissModule { [weak self] in
            guard let viewController = self?.router.navigationController.viewControllers
                .compactMap({ $0 as? CreateViewController }).first else { return }
            viewController.didPickedLocation(latitude: latitude, longitude: longitude)
        }
    }
}
