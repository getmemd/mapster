//
//  AppCoordinator.swift
//  Mapster
//
//  Created by User on 15.02.2024.
//

import Foundation

final class AppCoordinator: Coordinator {
    override func start() {
        // Запускаем процесс онбординга
        runOnboardingFlow()
    }
    
    private func runMainFlow() {
        // Создаем основной координатор, добавляем зависимость от координатора, запускаем процесс
        let coordinator = MainCoordinator(router: router, delegate: self)
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runOnboardingFlow() {
        // Создаем координатор онбординга, добавляем зависимость от координатора, запускаем процесс
        let coordinator = OnboardingCoordinator(router: router, delegate: self)
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runAuthorizationFlow() {
        // Создаем координатор авторизации, добавляем зависимость от координатора, запускаем процесс
        let coordinator = AuthorizationCoordinator(router: router, delegate: self)
        addDependency(coordinator)
        coordinator.start()
    }
}

// MARK: - MainCoordinatorDelegate

extension AppCoordinator: MainCoordinatorDelegate {
    func didFinish(_ coordinator: MainCoordinator) {
        // Удаляем зависимость от завершившегося основного координатора
        removeDependency(coordinator)
    }
}

// MARK: - OnboardingCoordinatorDelegate

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func didFinish(_ coordinator: OnboardingCoordinator) {
        // Удаляем зависимость от завершившегося координатора онбординга и запускаем процесс авторизации
        removeDependency(coordinator)
        runAuthorizationFlow()
    }
}

// MARK: - AuthorizationCoordinatorDelegate

extension AppCoordinator: AuthorizationCoordinatorDelegate {
    func didFinish(_ coordinator: AuthorizationCoordinator) {
        // Удаляем зависимость от завершившегося координатора авторизации и запускаем основной процесс
        removeDependency(coordinator)
        runMainFlow()
    }
}
