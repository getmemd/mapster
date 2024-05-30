import Factory

final class Repositories: SharedContainer {
    var manager = ContainerManager()
    static var shared = Repositories()
    
    var authRepository: Dependency<AuthRepository> {
        self { AuthRepository() }
    }
    
    var advertisementRepository: Dependency<AdvertisementRepository> {
        self { AdvertisementRepository() }
    }
    
    var imageRepository: Dependency<ImageRepository> {
        self { ImageRepository() }
    }
    
    var userRepository: Dependency<UserRepository> {
        self { UserRepository() }
    }
}
