//
//  AppCoordinator.swift
//  Mapster
//
//  Created by Адиль Медеуев on 15.02.2024.
//

import Foundation

final class AppCoordinator: Coordinator {
    override func start() {
        runOnboardingFlow()
    }
    
    private func runOnboardingFlow() {
        let coordinator = OnboardingCoordinator(router: router, delegate: self)
        addDependency(coordinator)
        coordinator.start()
    }
}

// MARK: - OnboardingCoordinatorDelegate

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func didFinish(_ coordinator: OnboardingCoordinator) {
        
    }
}
