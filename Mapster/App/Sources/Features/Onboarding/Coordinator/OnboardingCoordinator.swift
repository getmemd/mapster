import Foundation

protocol OnboardingCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: OnboardingCoordinator)
}

final class OnboardingCoordinator: Coordinator {
    private let delegate: OnboardingCoordinatorDelegate?
    private let moduleFactory = OnboardingModuleFactory()
    
    init(router: Router, delegate: OnboardingCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    override func start() {
        showOnboarding()
    }
    
    private func showOnboarding() {
        let module = moduleFactory.makeOnboarding(delegate: self)
        router.setRootModule(module)
    }
}

// MARK: - OnboardingNavigationDelegate

extension OnboardingCoordinator: OnboardingNavigationDelegate {
    func didFinishOnboarding(_ viewController: OnboardingViewController) {
        router.popModule()
        delegate?.didFinish(self)
    }
}
