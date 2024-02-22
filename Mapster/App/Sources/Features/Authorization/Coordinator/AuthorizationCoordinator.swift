//
//  AuthorizationCoordinator.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 18.02.2024.
//

import Foundation

protocol AuthorizationCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: AuthorizationCoordinator)
}

final class AuthorizationCoordinator: Coordinator {
    private weak var delegate: AuthorizationCoordinatorDelegate?
    private let moduleFactory = AuthorizationModuleFactory()
    
    init(router: Router, delegate: AuthorizationCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    override func start() {
        showAuthorization()
    }
    
    private func showAuthorization() {
        let module = moduleFactory.makeAuthorization(delegate: self)
        router.setRootModule(module)
    }
    
    private func showOTP(viewState: OTPViewController.ViewSate) {
        let module = moduleFactory.makeOTP(viewState: viewState, delegate: self)
        router.push(module)
    }
}

// MARK: - AuthorizationNavigationDelegate

extension AuthorizationCoordinator: AuthorizationNavigationDelegate {
    func didTapForgotPassword(_ viewController: AuthorizationViewController) {
        showOTP(viewState: .passwordReset)
    }
    
    func didFinishAuthorization(_ viewController: AuthorizationViewController) {
        
    }
    
    func didFinishRegistration(_ viewController: AuthorizationViewController) {
        
    }
}

// MARK: - OTPNavigationDelegate

extension AuthorizationCoordinator: OTPNavigationDelegate {
    func didFinish(_ viewController: OTPViewController) {
        
    }
}
