//
//  MainModuleFactory.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 28.05.2024.
//

import UIKit

final class MainModuleFactory {
    func makeMain(viewControllers: [UIViewController]) -> ContainerController {
        let containerController = ContainerController(viewControllers: viewControllers)
        return containerController
    }
}
