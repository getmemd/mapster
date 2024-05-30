import Foundation

final class OnboardingModuleFactory {
    func makeOnboarding(delegate: OnboardingNavigationDelegate) -> OnboardingViewController {
        let viewController = OnboardingViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
