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
        let module = moduleFactory.makeAuthorization()
        router.setRootModule(module)
    }
}
