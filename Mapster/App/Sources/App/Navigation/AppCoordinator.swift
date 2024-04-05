//
//  AppCoordinator.swift
//  Mapster
//
//  Created by User on 15.02.2024.
//

import FirebaseAuth

final class AppCoordinator: Coordinator {
    override func start() {
        // Проверям на появление онбординга и авторизацию
        if isFirstLaunch() {
            runOnboardingFlow()
        } else if isUserAuthorized() {
            runMainFlow()
        } else {
            runAuthorizationFlow()
        }
    }
    
    // Проверка на первый запуск
    private func isFirstLaunch() -> Bool {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if hasLaunchedBefore {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            return true
        }
    }
    
    // Проверка на авторизацию
    private func isUserAuthorized() -> Bool {
        return Auth.auth().currentUser != nil
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
        UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
        runOnboardingFlow()
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
