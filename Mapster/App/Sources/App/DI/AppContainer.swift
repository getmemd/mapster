//
//  AppContainer.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 07.03.2024.
//

import Factory
import FirebaseFirestore
import FirebaseStorage

typealias AppContainer = Container
typealias Dependency = Factory

extension AppContainer {
    var appCoordinator: Dependency<AppCoordinator> {
        self {
            AppCoordinator(router: .init(navigationController: .init()))
        }
    }
    
    var db: Dependency<Firestore> {
        self {
            Firestore.firestore()
        }
    }
    
    var storage: Dependency<Storage> {
        self {
            Storage.storage()
        }
    }
}
