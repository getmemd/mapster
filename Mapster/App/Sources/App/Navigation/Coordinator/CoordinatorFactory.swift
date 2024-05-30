import UIKit

final class CoordinatorFactory {
    func makeOnboarding(router: Router, delegate: OnboardingCoordinatorDelegate) -> Coordinator {
        OnboardingCoordinator(router: router, delegate: delegate)
    }
    
    func makeAuthorization(router: Router, delegate: AuthorizationCoordinatorDelegate) -> Coordinator {
        AuthorizationCoordinator(router: router, delegate: delegate)
    }
    
    func makeMain(router: Router, delegate: MainCoordinatorDelegate) -> Coordinator {
        MainCoordinator(router: router, delegate: delegate)
    }
}
