//
//  AppContainer.swift
//  Mapster
//
//  Created by User on 07.03.2024.
//

import Factory
import FirebaseFirestore

typealias AppContainer = Container
typealias Dependency = Factory

extension AppContainer {
    // Главный координатор
    var appCoordinator: Dependency<AppCoordinator> {
        self {
            AppCoordinator(router: .init(navigationController: .init()))
        }
    }
    
    // Облачная база данных
    var db: Dependency<Firestore> {
        self {
            Firestore.firestore()
        }
    }
}
