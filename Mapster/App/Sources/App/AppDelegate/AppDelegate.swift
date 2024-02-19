//
//  AppDelegate.swift
//  Mapster
//
//  Created by User on 15.02.2024.
//

import IQKeyboardManagerSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    // Создаем координатор приложения
    private lazy var applicationCoordinator: AppCoordinator = {
        // Получаем UINavigationController из корневого контроллера окна
        guard let navigationController = window?.rootViewController as? UINavigationController else {
            fatalError("rootViewController must be NavigationController")
        }
        // Создаем координатор приложения с переданным UINavigationController
        return AppCoordinator(router: Router(navigationController: navigationController))
    }()
    
    // Метод вызывается после запуска приложения
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Включаем управление клавиатурой
        IQKeyboardManager.shared.enable = true
        setupNavigation()
        return true
    }
    
    // Настройка навигации
    private func setupNavigation() {
        // Создаем и настраиваем окно приложения
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.makeKeyAndVisible()
        // Создаем корневой контроллер и назначаем его
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        // Запускаем координатор приложения
        applicationCoordinator.start()
    }
}

