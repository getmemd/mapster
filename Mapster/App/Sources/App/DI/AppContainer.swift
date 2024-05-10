import Factory
import FirebaseFirestore

typealias AppContainer = Container
typealias Dependency = Factory

extension AppContainer {
    // Главный координатор
    var appCoordinator: Dependency<AppCoordinator> {
        self {
            AppCoordinator(router: .init(navigationController: .init()))
        }
    }
    
    // Облачная база данных
    var db: Dependency<Firestore> {
        self {
            Firestore.firestore()
        }
    }
}
