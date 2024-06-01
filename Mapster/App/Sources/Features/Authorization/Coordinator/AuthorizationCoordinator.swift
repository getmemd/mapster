import Foundation

// Протокол делегата для координатора авторизации
protocol AuthorizationCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: AuthorizationCoordinator)
}

// Финальный класс для координатора авторизации
final class AuthorizationCoordinator: Coordinator {
    private let delegate: AuthorizationCoordinatorDelegate?
    private let moduleFactory = AuthorizationModuleFactory()
    
    // Инициализация с роутером и делегатом
    init(router: Router, delegate: AuthorizationCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    // Запуск координатора
    override func start() {
        showAuthorization()
    }
    
    // Показ модуля авторизации
    private func showAuthorization() {
        let module = moduleFactory.makeAuthorization(delegate: self)
        router.setRootModule(module)
    }
    
    // Показ модуля OTP
    private func showOTP(viewState: OTPViewController.ViewSate) {
        let module = moduleFactory.makeOTP(viewState: viewState, delegate: self)
        router.push(module)
    }
    
    // Показ модуля сброса пароля
    private func showPasswordReset() {
        let module = moduleFactory.makePasswordReset(delegate: self)
        router.push(module)
    }
}

// MARK: - AuthorizationNavigationDelegate

// Расширение для обработки навигации из модуля авторизации
extension AuthorizationCoordinator: AuthorizationNavigationDelegate {
    func didFinishAuthorization(_ viewController: AuthorizationViewController) {
        delegate?.didFinish(self)
    }
}

// MARK: - OTPNavigationDelegate

// Расширение для обработки навигации из модуля OTP
extension AuthorizationCoordinator: OTPNavigationDelegate {
    func didConfirmForLogin(_ viewController: OTPViewController) {
        delegate?.didFinish(self)
    }
    
    func didConfirmForPasswordReset(_ viewController: OTPViewController) {
        showPasswordReset()
    }
}

// MARK: - PasswordResetNavigationDelegate

// Расширение для обработки навигации из модуля сброса пароля
extension AuthorizationCoordinator: PasswordResetNavigationDelegate {
    func didFinish(_ viewController: PasswordResetViewController) {
        router.popToRootModule()
    }
}
