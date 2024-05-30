import Factory

// Класс для хранения репозиториев
final class Repositories: SharedContainer {
    // Менеджер контейнеров
    var manager = ContainerManager()
    // Singleton экземпляр класса
    static var shared = Repositories()
    
    // Репозиторий аутентификации
    var authRepository: Dependency<AuthRepository> {
        self { AuthRepository() }
    }
    
    // Репозиторий для объявлений
    var advertisementRepository: Dependency<AdvertisementRepository> {
        self { AdvertisementRepository() }
    }
    
    // Репозиторий для изображений
    var imageRepository: Dependency<ImageRepository> {
        self { ImageRepository() }
    }
    
    // Репозиторий пользователей
    var userRepository: Dependency<UserRepository> {
        self { UserRepository() }
    }
}
