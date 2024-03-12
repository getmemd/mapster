//
//  AppContainer.swift
//  Mapster
//
//  Created by User on 07.03.2024.
//

import Factory

typealias AppContainer = Container
typealias Dependency = Factory

extension AppContainer {
    // Главный координатор
    var appCoordinator: Dependency<AppCoordinator> {
        self {
            AppCoordinator(router: .init(navigationController: .init()))
        }
    }
}
