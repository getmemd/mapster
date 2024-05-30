import Foundation

protocol CreateCoordinatorDelegate: AnyObject {
    func needsUpdate(_ coordinator: CreateCoordinator)
}

final class CreateCoordinator: Coordinator {
    private weak var delegate: CreateCoordinatorDelegate?
    private let moduleFactory = CreateModuleFactory()
    
    init(router: Router, delegate: CreateCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    override func start() {
        showCreate()
    }
    
    private func showCreate() {
        let module = moduleFactory.makeCreate(delegate: self)
        router.setRootModule(module)
    }
    
    private func showMap() {
        let module = moduleFactory.makeMap(delegate: self)
        router.present(module, animated: true, modalPresentationStyle: .overFullScreen)
    }
}

// MARK: - CreateNavigationDelegate

extension CreateCoordinator: CreateNavigationDelegate {
    func didTapMap(_ viewController: CreateViewController) {
        showMap()
    }
    
    func didCreateAdvertisement(_ viewController: CreateViewController) {
        delegate?.needsUpdate(self)
    }
}

// MARK: - MapNavigationDelegate

extension CreateCoordinator: MapNavigationDelegate {
    func didTapActionButton(_ viewController: MapViewController, latitude: Double, longitude: Double) {
        router.dismissModule { [weak self] in
            guard let viewController = self?.router.navigationController.viewControllers
                .compactMap({ $0 as? CreateViewController }).first else { return }
            viewController.didPickedLocation(latitude: latitude, longitude: longitude)
        }
    }
}
