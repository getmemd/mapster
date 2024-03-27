//
//  OnboardingCoordinator.swift
//  Mapster
//
//  Created by User on 17.02.2024.
//

import Foundation

// Протокол делегата координатора онбординга
protocol OnboardingCoordinatorDelegate: AnyObject {
    // Метод вызывается после завершения работы координатора онбординга
    func didFinish(_ coordinator: OnboardingCoordinator)
}

// Координатор для управления процессом онбординга
final class OnboardingCoordinator: Coordinator {
    private let delegate: OnboardingCoordinatorDelegate?
    private let moduleFactory = OnboardingModuleFactory()
    
    // Инициализатор координатора онбординга
    init(router: Router, delegate: OnboardingCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    // Метод запускает процесс онбординга
    override func start() {
        showOnboarding()
    }
    
    // Метод отображает экран онбординга
    private func showOnboarding() {
        let module = moduleFactory.makeOnboarding(delegate: self)
        router.setRootModule(module) // Устанавливаем экран онбординга как корневой
    }
}

// MARK: - OnboardingNavigationDelegate

extension OnboardingCoordinator: OnboardingNavigationDelegate {
    // Метод, вызываемый после завершения просмотра экрана
    func didFinishOnboarding(_ viewController: OnboardingViewController) {
        router.popModule() // Удаляем текущий модуль из стека навигации
        delegate?.didFinish(self) // Сообщаем делегату о завершении работы координатора
    }
}

