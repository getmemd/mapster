import Foundation

// Протокол делегата для ProfileCoordinator
protocol ProfileCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: ProfileCoordinator)
    func needsUpdate(_ coordinator: ProfileCoordinator)
}

// Координатор для управления профилем пользователя
final class ProfileCoordinator: Coordinator {
    private weak var delegate: ProfileCoordinatorDelegate?
    private let moduleFactory = ProfileModuleFactory()
    
    // Инициализация с роутером и делегатом
    init(router: Router, delegate: ProfileCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    // Запуск процесса профиля
    override func start() {
        showProfile()
    }
    
    // Отображение профиля пользователя
    private func showProfile() {
        let module = moduleFactory.makeProfile(delegate: self)
        router.setRootModule(module)
    }
    
    // Отображение редактирования профиля
    private func showProfileEdit() {
        let module = moduleFactory.makeProfileEdit(delegate: self)
        router.push(module)
    }
    
    // Отображение списка объявлений пользователя
    private func showMyAdvertisements() {
        let module = moduleFactory.makeAdvertisementsList(delegate: self)
        router.push(module)
    }
    
    // Отображение конкретного объявления
    private func showAdvertisement(advertisement: Advertisement) {
        let module = moduleFactory.makeAdvertisement(delegate: self, advertisement: advertisement)
        router.push(module)
    }
    
    // Отображение политики конфиденциальности
    private func showPolicy() {
        let module = moduleFactory.makePolicy(delegate: self)
        router.present(module)
    }
}

// MARK: - ProfileNavigationDelegate

// Расширение для обработки навигации в профиле
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

// Расширение для обработки навигации в редактировании профиля
extension ProfileCoordinator: ProfileEditNavigationDelegate {
    func didFinish(_ viewController: ProfileEditViewController) {
        router.popModule()
    }
}

// MARK: - AdvertisementsListNavigationDelegate

// Расширение для обработки навигации в списке объявлений
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

// Расширение для обработки навигации в информации
extension ProfileCoordinator: InfoNavigationDelegate {
    func didTapClose(_ viewController: InfoViewController) {
        router.dismissModule()
    }
}
