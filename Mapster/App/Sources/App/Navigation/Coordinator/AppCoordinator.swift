import FirebaseAuth
import UIKit

// Основной координатор приложения
final class AppCoordinator: Coordinator {
    // Фабрика координаторов
    private let coordinatorFactory: CoordinatorFactory = .init()
    
    // Запуск координатора
    override func start() {
        if isFirstLaunch() {
            runOnboardingFlow()
        } else if isUserAuthorized() {
            runMainFlow()
        } else {
            runAuthorizationFlow()
        }
    }
    
    // Проверка первого запуска приложения
    private func isFirstLaunch() -> Bool {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if hasLaunchedBefore {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            return true
        }
    }
    
    // Проверка авторизации пользователя
    private func isUserAuthorized() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    // Запуск основного потока
    private func runMainFlow() {
        let coordinator = coordinatorFactory.makeMain(router: router, delegate: self)
        addDependency(coordinator)
        coordinator.start()
    }
    
    // Запуск онбординга
    private func runOnboardingFlow() {
        let coordinator = coordinatorFactory.makeOnboarding(router: router, delegate: self)
        addDependency(coordinator)
        coordinator.start()
    }
    
    // Запуск авторизации
    private func runAuthorizationFlow() {
        let coordinator = coordinatorFactory.makeAuthorization(router: router, delegate: self)
        addDependency(coordinator)
        coordinator.start()
    }
}

// MARK: - MainCoordinatorDelegate

// Расширение для обработки событий основного координатора
extension AppCoordinator: MainCoordinatorDelegate {
    func didFinish(_ coordinator: MainCoordinator) {
        UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
        removeDependency(coordinator)
        runOnboardingFlow()
    }
}

// MARK: - OnboardingCoordinatorDelegate

// Расширение для обработки событий координатора онбординга
extension AppCoordinator: OnboardingCoordinatorDelegate {
    func didFinish(_ coordinator: OnboardingCoordinator) {
        removeDependency(coordinator)
        runAuthorizationFlow()
    }
}

// MARK: - AuthorizationCoordinatorDelegate

// Расширение для обработки событий координатора авторизации
extension AppCoordinator: AuthorizationCoordinatorDelegate {
    func didFinish(_ coordinator: AuthorizationCoordinator) {
        removeDependency(coordinator)
        runMainFlow()
    }
}
