//
//  AppCoordinator.swift
//  Mapster
//
//  Created by Адиль Медеуев on 15.02.2024.
//

import Foundation

final class AppCoordinator: Coordinator {
    override func start() {
        runAuthorizationFlow()
    }
    
    private func runOnboardingFlow() {
        let coordinator = OnboardingCoordinator(router: router, delegate: self)
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runAuthorizationFlow() {
        let coordinator = AuthorizationCoordinator(router: router, delegate: self)
        addDependency(coordinator)
        coordinator.start()
    }
}

// MARK: - OnboardingCoordinatorDelegate

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func didFinish(_ coordinator: OnboardingCoordinator) {
        removeDependency(coordinator)
        runAuthorizationFlow()
    }
}

// MARK: - AuthorizationCoordinatorDelegate

extension AppCoordinator: AuthorizationCoordinatorDelegate {
    func didFinish(_ coordinator: AuthorizationCoordinator) {
        removeDependency(coordinator)
        
    }
}
