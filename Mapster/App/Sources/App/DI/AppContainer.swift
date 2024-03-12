//
//  AppContainer.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 07.03.2024.
//

import Factory

typealias AppContainer = Container
typealias Dependency = Factory

extension AppContainer {
    var appCoordinator: Dependency<AppCoordinator> {
        self {
            AppCoordinator(router: .init(navigationController: .init()))
        }
    }
}
