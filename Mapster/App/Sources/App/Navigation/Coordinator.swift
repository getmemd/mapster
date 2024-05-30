import Foundation

class Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    public let router: Router
    private weak var parentCoordinator: Coordinator?
    
    public init(router: Router) {
        self.router = router
    }

    open func start() {}

    public func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }

    public func removeDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.isEmpty else { return }
        coordinator.childCoordinators.filter { $0 !== coordinator }.forEach { coordinator.removeDependency($0) }
        childCoordinators.removeAll { $0 === coordinator }
    }

    public func clearChildCoordinators() {
        childCoordinators.forEach { removeDependency($0) }
    }
}
