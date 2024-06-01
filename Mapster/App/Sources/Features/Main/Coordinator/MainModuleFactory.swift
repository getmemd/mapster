import UIKit

// Фабрика для создания главного модуля
final class MainModuleFactory {
    // Создание главного контейнерного контроллера с набором viewControllers
    func makeMain(viewControllers: [UIViewController]) -> ContainerController {
        let containerController = ContainerController(viewControllers: viewControllers)
        return containerController
    }
}
