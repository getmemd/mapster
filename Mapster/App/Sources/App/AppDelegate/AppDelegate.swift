//
//  AppDelegate.swift
//  Mapster
//
//  Created by Адиль Медеуев on 15.02.2024.
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
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Auth.auth().useAppLanguage()
        setupCoordinator()
        return true
    }
    
    private func setupCoordinator() {
        let container = AppContainer.shared
        let navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        container.appCoordinator.register {
            AppCoordinator(router: .init(navigationController: navigationController))
        }
        container.appCoordinator().start()
    }
}
