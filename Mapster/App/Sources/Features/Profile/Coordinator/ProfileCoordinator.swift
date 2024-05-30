import Foundation

protocol ProfileCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: ProfileCoordinator)
    func needsUpdate(_ coordinator: ProfileCoordinator)
}

final class ProfileCoordinator: Coordinator {
    private weak var delegate: ProfileCoordinatorDelegate?
    private let moduleFactory = ProfileModuleFactory()
    
    init(router: Router, delegate: ProfileCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    override func start() {
        showProfile()
    }
    
    private func showProfile() {
        let module = moduleFactory.makeProfile(delegate: self)
        router.setRootModule(module)
    }
    
    private func showProfileEdit() {
        let module = moduleFactory.makeProfileEdit(delegate: self)
        router.push(module)
    }
    
    private func showMyAdvertisements() {
        let module = moduleFactory.makeAdvertisementsList(delegate: self)
        router.push(module)
    }
    
    private func showAdvertisement(advertisement: Advertisement) {
        let module = moduleFactory.makeAdvertisement(delegate: self, advertisement: advertisement)
        router.push(module)
    }
    
    private func showPolicy() {
        let module = moduleFactory.makePolicy(delegate: self)
        router.present(module)
    }
}

// MARK: - ProfileNavigationDelegate

extension ProfileCoordinator: ProfileNavigationDelegate {
    func didTapRow(_ viewController: ProfileViewController, row: ProfileRows) {
        switch row {
        case .editProfile:
            showProfileEdit()
        case .myAdvertisements:
            showMyAdvertisements()
        case .policy:
            showPolicy()
        default:
            return
        }
    }
    
    func didSignOut(_ viewController: ProfileViewController) {
        delegate?.didFinish(self)
    }
}

// MARK: - ProfileEditNavigationDelegate

extension ProfileCoordinator: ProfileEditNavigationDelegate {
    func didFinish(_ viewController: ProfileEditViewController) {
        router.popModule()
    }
}

// MARK: - AdvertisementsListNavigationDelegate

extension ProfileCoordinator: AdvertisementsListNavigationDelegate {
    func didTapAdvertisement(_ viewController: AdvertisementsListViewController, advertisement: Advertisement) {
        showAdvertisement(advertisement: advertisement)
    }
    
    func didDeleteAdvertisement(_ viewController: AdvertisementsListViewController) {
        delegate?.needsUpdate(self)
    }
}

// MARK: - AdvertisementNavigationDelegate

extension ProfileCoordinator: AdvertisementNavigationDelegate {
    
}

// MARK: - InfoNavigationDelegate

extension ProfileCoordinator: InfoNavigationDelegate {
    func didTapClose(_ viewController: InfoViewController) {
        router.dismissModule()
    }
}
