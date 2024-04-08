//
//  Repositories.swift
//  Mapster
//
//  Created by User on 07.03.2024.
//

import Factory

final class Repositories: SharedContainer {
    var manager = ContainerManager()
    static var shared = Repositories()
    
    // Репозиторий авторизации
    var authRepository: Dependency<AuthRepository> {
        self { AuthRepository() }
    }
    
    var advertisementRepository: Dependency<AdvertisementRepository> {
        self { AdvertisementRepository() }
    }
    
    var imageRepository: Dependency<ImageRepository> {
        self { ImageRepository() }
    }
}
