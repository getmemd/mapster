//
//  AppCoordinator.swift
//  Mapster
//
//  Created by User on 15.02.2024.
//

import Foundation

final class AppCoordinator: Coordinator {
    override func start() {
        runOnboardingFlow() // Запускаем процесс онбординга
    }
    
    private func runMainFlow() {
        let coordinator = MainCoordinator(router: router, delegate: self)
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runOnboardingFlow() {
        let coordinator = OnboardingCoordinator(router: router, delegate: self) // Создаем координатор онбординга
        addDependency(coordinator) // Добавляем зависимость от координатора онбординга
        coordinator.start() // Запускаем процесс онбординга
    }
    
    private func runAuthorizationFlow() {
        let coordinator = AuthorizationCoordinator(router: router, delegate: self) // Создаем координатор авторизации
        addDependency(coordinator) // Добавляем зависимость от координатора авторизации
        coordinator.start() // Запускаем процесс авторизации
    }
}

// MARK: - MainCoordinatorDelegate

extension AppCoordinator: MainCoordinatorDelegate {
    func didFinish(_ coordinator: MainCoordinator) {
        removeDependency(coordinator)
    }
}

// MARK: - OnboardingCoordinatorDelegate

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func didFinish(_ coordinator: OnboardingCoordinator) {
        removeDependency(coordinator) // Удаляем зависимость от завершившегося координатора онбординга
        runAuthorizationFlow() // Запускаем процесс авторизации
    }
}

// MARK: - AuthorizationCoordinatorDelegate

extension AppCoordinator: AuthorizationCoordinatorDelegate {
    func didFinish(_ coordinator: AuthorizationCoordinator) {
        removeDependency(coordinator) // Удаляем зависимость от завершившегося координатора авторизации
        runMainFlow()
    }
}
