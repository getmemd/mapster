import UIKit

// Фабрика для создания координаторов
final class CoordinatorFactory {
    // Создание координатора онбординга
    func makeOnboarding(router: Router, delegate: OnboardingCoordinatorDelegate) -> Coordinator {
        OnboardingCoordinator(router: router, delegate: delegate)
    }
    
    // Создание координатора авторизации
    func makeAuthorization(router: Router, delegate: AuthorizationCoordinatorDelegate) -> Coordinator {
        AuthorizationCoordinator(router: router, delegate: delegate)
    }
    
    // Создание основного координатора
    func makeMain(router: Router, delegate: MainCoordinatorDelegate) -> Coordinator {
        MainCoordinator(router: router, delegate: delegate)
    }
}
