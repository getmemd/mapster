import Foundation

// Протокол делегата для OnboardingCoordinator
protocol OnboardingCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: OnboardingCoordinator)
}

// Координатор для управления процессом онбординга
final class OnboardingCoordinator: Coordinator {
    private let delegate: OnboardingCoordinatorDelegate?
    private let moduleFactory = OnboardingModuleFactory()
    
    // Инициализация с роутером и делегатом
    init(router: Router, delegate: OnboardingCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    // Запуск процесса онбординга
    override func start() {
        showOnboarding()
    }
    
    // Отображение модуля онбординга
    private func showOnboarding() {
        let module = moduleFactory.makeOnboarding(delegate: self)
        router.setRootModule(module)
    }
}

// MARK: - OnboardingNavigationDelegate

// Расширение для обработки завершения онбординга
extension OnboardingCoordinator: OnboardingNavigationDelegate {
    func didFinishOnboarding(_ viewController: OnboardingViewController) {
        router.popModule()
        delegate?.didFinish(self)
    }
}
