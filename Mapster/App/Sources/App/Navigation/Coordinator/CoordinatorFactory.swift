//
//  CoordinatorFactory.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 28.05.2024.
//

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
