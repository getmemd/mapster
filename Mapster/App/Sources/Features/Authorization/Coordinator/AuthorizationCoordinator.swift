//
//  AuthorizationCoordinator.swift
//  Mapster
//
//  Created by User on 18.02.2024.
//

import Foundation

// Протокол делегата координатора авторизации
protocol AuthorizationCoordinatorDelegate: AnyObject {
    // Метод вызывается после завершения работы координатора авторизации
    func didFinish(_ coordinator: AuthorizationCoordinator)
}

// Координатор для управления процессом авторизации
final class AuthorizationCoordinator: Coordinator {
    // Слабая ссылка на делегата координатора авторизации
    private weak var delegate: AuthorizationCoordinatorDelegate?
    // Фабрика модулей авторизации
    private let moduleFactory = AuthorizationModuleFactory()
    
    // Инициализатор координатора авторизации
    init(router: Router, delegate: AuthorizationCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    // Метод запускает процесс авторизации
    override func start() {
        showAuthorization()
    }
    
    // Метод отображает экран авторизации
    private func showAuthorization() {
        let module = moduleFactory.makeAuthorization()
        router.setRootModule(module) // Устанавливаем экран авторизации как корневой
    }
    
    private func showOTP(viewState: OTPViewController.ViewSate) {
        let module = moduleFactory.makeOTP(viewState: viewState, delegate: self)
        router.push(module)
    }
    
    private func showPasswordReset() {
        let module = moduleFactory.makePasswordReset(delegate: self)
        router.push(module)
    }
}

// MARK: - AuthorizationNavigationDelegate

extension AuthorizationCoordinator: AuthorizationNavigationDelegate {
    func didTapForgotPassword(_ viewController: AuthorizationViewController) {
        showOTP(viewState: .passwordReset)
    }
    
    func didFinishAuthorization(_ viewController: AuthorizationViewController) {
        delegate?.didFinish(self)
    }
    
    func didFinishRegistration(_ viewController: AuthorizationViewController) {
        showOTP(viewState: .registration)
    }
}

// MARK: - OTPNavigationDelegate

extension AuthorizationCoordinator: OTPNavigationDelegate {
    func didConfirmForLogin(_ viewController: OTPViewController) {
        delegate?.didFinish(self)
    }
    
    func didConfirmForPasswordReset(_ viewController: OTPViewController) {
        showPasswordReset()
    }
}

// MARK: - PasswordResetNavigationDelegate

extension AuthorizationCoordinator: PasswordResetNavigationDelegate {
    func didFinish(_ viewController: PasswordResetViewController) {
        router.popToRootModule()
    }
}
