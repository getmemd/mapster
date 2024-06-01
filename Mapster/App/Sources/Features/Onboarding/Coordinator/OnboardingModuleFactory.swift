import Foundation

// Фабрика для создания модуля онбординга
final class OnboardingModuleFactory {
    // Создание и настройка OnboardingViewController с делегатом
    func makeOnboarding(delegate: OnboardingNavigationDelegate) -> OnboardingViewController {
        let viewController = OnboardingViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
