import UIKit

final class MainModuleFactory {
    func makeMain(viewControllers: [UIViewController]) -> ContainerController {
        let containerController = ContainerController(viewControllers: viewControllers)
        return containerController
    }
}
