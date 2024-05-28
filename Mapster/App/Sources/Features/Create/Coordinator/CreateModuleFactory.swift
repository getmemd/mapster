//
//  CreateModuleFactory.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 28.05.2024.
//

import Foundation

final class CreateModuleFactory {
    func makeCreate(delegate: CreateNavigationDelegate) -> CreateViewController {
        let viewController = CreateViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    func makeMap(delegate: MapNavigationDelegate) -> MapViewController {
        let viewController = MapViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
