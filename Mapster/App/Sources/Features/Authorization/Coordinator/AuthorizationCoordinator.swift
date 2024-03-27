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
    private let delegate: AuthorizationCoordinatorDelegate?
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
        let module = moduleFactory.makeAuthorization(delegate: self)
        router.setRootModule(module) // Устанавливаем экран авторизации как корневой
    }
    
    // Метод отображает экран ввода OTP
    private func showOTP(viewState: OTPViewController.ViewSate) {
        let module = moduleFactory.makeOTP(viewState: viewState, delegate: self)
        router.push(module)
    }
    
    // Метод отображает экран сброса пароля
    private func showPasswordReset() {
        let module = moduleFactory.makePasswordReset(delegate: self)
        router.push(module)
    }
}

// MARK: - AuthorizationNavigationDelegate

extension AuthorizationCoordinator: AuthorizationNavigationDelegate {
    // Закрыть координатор после авторизации
    func didFinishAuthorization(_ viewController: AuthorizationViewController) {
        delegate?.didFinish(self)
    }
}

// MARK: - OTPNavigationDelegate

extension AuthorizationCoordinator: OTPNavigationDelegate {
    // Закрыть координатор после успешного ввода OTP
    func didConfirmForLogin(_ viewController: OTPViewController) {
        delegate?.didFinish(self)
    }
    
    // Показать экран сброса пароля после успешного ввода OTP
    func didConfirmForPasswordReset(_ viewController: OTPViewController) {
        showPasswordReset()
    }
}

// MARK: - PasswordResetNavigationDelegate

extension AuthorizationCoordinator: PasswordResetNavigationDelegate {
    // Возврат к корневому модулю после сброса пароля
    func didFinish(_ viewController: PasswordResetViewController) {
        router.popToRootModule()
    }
}
