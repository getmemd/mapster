//
//  Coordinator.swift
//  Mapster
//
//  Created by User on 15.02.2024.
//

import Foundation

class Coordinator {
    // Дочерние координаторы
    private(set) var childCoordinators: [Coordinator] = []
    // Роутер для навигации
    let router: Router
    // Родительский координатор
    private weak var parentCoordinator: Coordinator?
    
    init(router: Router) {
        self.router = router
    }

    func start() {}

    // Добавить зависимость координатора
    func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }
    
    // Удалить зависимость координатора
    func removeDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.isEmpty else { return }
        coordinator.childCoordinators.filter { $0 !== coordinator }.forEach { coordinator.removeDependency($0) }
        childCoordinators.removeAll { $0 === coordinator }
    }

    // Очистить зависимости координатора
    func clearChildCoordinators() {
        childCoordinators.forEach { removeDependency($0) }
    }
}
