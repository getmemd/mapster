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
