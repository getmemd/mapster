//
//  MainCoordinator.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 26.02.2024.
//

import Foundation
import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: MainCoordinator)
}

final class MainCoordinator: Coordinator {
    private let delegate: MainCoordinatorDelegate?
    private let moduleFactory = MainModuleFactory()
    
    init(router: Router, delegate: MainCoordinatorDelegate?) {
        self.delegate = delegate
        super.init(router: router)
    }
    
    override func start() {
        showTabBar()
    }
    
    private func showTabBar() {
        let homeModule = moduleFactory.makeHome(delegate: self)
        let search = moduleFactory.makeSearch(delegate: self)
        search.tabBarItem = .init(title: "Поиск", image: .init(named: "search"), tag: 1)
        let add = UIViewController()
        add.tabBarItem = .init(title: "Создать", image: .init(named: "create"), tag: 2)
        let bookmark = moduleFactory.makeFavourites(delegate: self)
        bookmark.tabBarItem = .init(title: "Избранные", image: .init(named: "bookmark"), tag: 3)
        let profile = UIViewController()
        profile.tabBarItem = .init(title: "Профиль", image: .init(named: "profile"), tag: 4)
        let module = moduleFactory.makeTabBar(viewControllers: [homeModule, search, add, bookmark, profile])
        router.setRootModule(module)
    }
}

// MARK: - HomeNavigationDelegate

extension MainCoordinator: HomeNavigationDelegate {
    
}

// MARK: - FavouritesNavigationDelegate

extension MainCoordinator: FavouritesNavigationDelegate {
    
}

// MARK: - SearchNavigationDelegate

extension MainCoordinator: SearchNavigationDelegate {
    
}
