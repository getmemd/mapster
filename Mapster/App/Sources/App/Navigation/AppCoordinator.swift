//
//  AppCoordinator.swift
//  Mapster
//
//  Created by Адиль Медеуев on 15.02.2024.
//

import FirebaseAuth

final class AppCoordinator: Coordinator {
    override func start() {
        if isFirstLaunch() {
            runOnboardingFlow()
        } else if isUserAuthorized() {
            runMainFlow()
        } else {
            runAuthorizationFlow()
        }
    }
    
    private func isFirstLaunch() -> Bool {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if hasLaunchedBefore {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            return true
        }
    }
    
    private func isUserAuthorized() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    private func runMainFlow() {
        let coordinator = MainCoordinator(router: router, delegate: self)
        addDependency(coordinator)
        coordinator.start()
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

// MARK: - MainCoordinatorDelegate

extension AppCoordinator: MainCoordinatorDelegate {
    func didFinish(_ coordinator: MainCoordinator) {
        removeDependency(coordinator)
        UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
        runOnboardingFlow()
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
        runMainFlow()
    }
}
