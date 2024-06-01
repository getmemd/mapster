import Foundation

// Финальный класс для фабрики модулей создания
final class CreateModuleFactory {
    // Создание модуля создания
    func makeCreate(delegate: CreateNavigationDelegate) -> CreateViewController {
        let viewController = CreateViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
    
    // Создание модуля карты
    func makeMap(delegate: MapNavigationDelegate) -> MapViewController {
        let viewController = MapViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
