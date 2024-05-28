//
//  MainCoordinator.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 28.05.2024.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: MainCoordinator)
}

final class MainCoordinator: Coordinator {
    private weak var delegate: MainCoordinatorDelegate?
    private let coordinatorFactory = MainCoordinatorFactory()
    private let moduleFactory = MainModuleFactory()
    
    init(router: Router, delegate: MainCoordinatorDelegate) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    override func start() {
        showMain()
    }
    
    private func updateData() {
        guard let container = router.navigationController.viewControllers
            .compactMap({ $0 as? ContainerController }).first,
              let navigationControllers = container.viewControllers?
            .compactMap({ $0 as? UINavigationController }) else { return }
        let updatableControllers = navigationControllers.flatMap { $0.viewControllers.compactMap { $0 as? Updatable } }
        updatableControllers.forEach { $0.refreshData() }
    }
    
    private func showMain() {
        let main = moduleFactory.makeMain(viewControllers: [
            runHomeFlow(),
            runSearchFlow(),
            runCreateFlow(),
            runFavouritesFlow(),
            runProfileFlow()
        ])
        router.setRootModule(main, isNavigationBarHidden: true)
    }
    
    private func runHomeFlow() -> UIViewController {
        let (coordinator, module) = coordinatorFactory.makeHome()
        coordinator.start()
        addDependency(coordinator)
        return module
    }
    
    private func runSearchFlow() -> UIViewController {
        let (coordinator, module) = coordinatorFactory.makeSearch()
        coordinator.start()
        addDependency(coordinator)
        return module
    }
    
    private func runCreateFlow() -> UIViewController {
        let (coordinator, module) = coordinatorFactory.makeCreate(delegate: self)
        coordinator.start()
        addDependency(coordinator)
        return module
    }
    
    private func runFavouritesFlow() -> UIViewController {
        let (coordinator, module) = coordinatorFactory.makeFavourites(delegate: self)
        coordinator.start()
        addDependency(coordinator)
        return module
    }
    
    private func runProfileFlow() -> UIViewController {
        let (coordinator, module) = coordinatorFactory.makeProfile(delegate: self)
        coordinator.start()
        addDependency(coordinator)
        return module
    }
}

// MARK: - CreateCoordinatorDelegate

extension MainCoordinator: CreateCoordinatorDelegate {
    func needsUpdate(_ coordinator: CreateCoordinator) {
        updateData()
    }
}

// MARK: - FavouritesCoordinatorDelegate

extension MainCoordinator: FavouritesCoordinatorDelegate {
    func needsUpdate(_ coordinator: FavouritesCoordinator) {
        updateData()
    }
}

// MARK: - ProfileCoordinatorDelegate

extension MainCoordinator: ProfileCoordinatorDelegate {
    func didFinish(_ coordinator: ProfileCoordinator) {
        removeDependency(coordinator)
        delegate?.didFinish(self)
    }
    
    func needsUpdate(_ coordinator: ProfileCoordinator) {
        updateData()
    }
}
