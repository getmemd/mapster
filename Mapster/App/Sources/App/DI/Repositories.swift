//
//  Repositories.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 07.03.2024.
//

import Factory

final class Repositories: SharedContainer {
    var manager = ContainerManager()
    static var shared = Repositories()
    
    // Репозиторий авторизации
    var authRepository: Dependency<AuthRepository> {
        self { AuthRepository() }
    }
}
