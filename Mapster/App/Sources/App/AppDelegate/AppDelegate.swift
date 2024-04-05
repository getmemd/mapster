//
//  AppDelegate.swift
//  Mapster
//
//  Created by User on 15.02.2024.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import IQKeyboardManagerSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Включаем управление клавиатурой
        IQKeyboardManager.shared.enable = true
        // Настраиваем Firebase
        FirebaseApp.configure()
        Auth.auth().useAppLanguage()
        setupCoordinator()
        return true
    }
    
    // Настройка навигации
    private func setupCoordinator() {
        // Создание контейнера
        let container = AppContainer.shared
        let navigationController = UINavigationController()
        // Создание окна
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        // Создание координатора в контейнере
        container.appCoordinator.register {
            AppCoordinator(router: .init(navigationController: navigationController))
        }
        // Запуск координатора
        container.appCoordinator().start()
    }
}

