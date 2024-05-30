import Foundation

// Базовый класс для всех координаторов
class Coordinator {
    // Массив дочерних координаторов
    private(set) var childCoordinators: [Coordinator] = []
    // Роутер для навигации
    public let router: Router
    // Слабая ссылка на родительский координатор
    private weak var parentCoordinator: Coordinator?
    
    // Инициализация с роутером
    public init(router: Router) {
        self.router = router
    }

    // Метод для запуска координатора
    open func start() {}

    // Добавление дочернего координатора
    public func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }

    // Удаление дочернего координатора
    public func removeDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.isEmpty else { return }
        coordinator.childCoordinators.filter { $0 !== coordinator }.forEach { coordinator.removeDependency($0) }
        childCoordinators.removeAll { $0 === coordinator }
    }

    // Очистка всех дочерних координаторов
    public func clearChildCoordinators() {
        childCoordinators.forEach { removeDependency($0) }
    }
}
