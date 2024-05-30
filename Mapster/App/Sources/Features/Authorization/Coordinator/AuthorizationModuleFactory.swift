import Foundation

final class AuthorizationModuleFactory {
    func makeAuthorization(delegate: AuthorizationNavigationDelegate) -> AuthorizationViewController {
        let viewController = AuthorizationViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeOTP(viewState: OTPViewController.ViewSate, delegate: OTPNavigationDelegate) -> OTPViewController {
        let viewController = OTPViewController(viewState: viewState)
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makePasswordReset(delegate: PasswordResetNavigationDelegate) -> PasswordResetViewController {
        let viewController = PasswordResetViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
