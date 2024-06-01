import Foundation

// Финальный класс для фабрики модулей авторизации
final class AuthorizationModuleFactory {
    // Создание модуля авторизации
    func makeAuthorization(delegate: AuthorizationNavigationDelegate) -> AuthorizationViewController {
        let viewController = AuthorizationViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    // Создание модуля OTP
    func makeOTP(viewState: OTPViewController.ViewSate, delegate: OTPNavigationDelegate) -> OTPViewController {
        let viewController = OTPViewController(viewState: viewState)
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    // Создание модуля сброса пароля
    func makePasswordReset(delegate: PasswordResetNavigationDelegate) -> PasswordResetViewController {
        let viewController = PasswordResetViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
