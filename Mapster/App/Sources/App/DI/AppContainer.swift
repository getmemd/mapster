import Factory
import FirebaseFirestore
import FirebaseStorage

// Псевдоним для контейнера зависимостей
typealias AppContainer = Container
typealias Dependency = Factory

// Расширение для AppContainer
extension AppContainer {
    // Свойство для доступа к Firestore
    var db: Dependency<Firestore> {
        self {
            Firestore.firestore()
        }
    }
    
    // Свойство для доступа к Storage
    var storage: Dependency<Storage> {
        self {
            Storage.storage()
        }
    }
}
