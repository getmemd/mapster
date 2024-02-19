//
//  AppDelegate.swift
//  Mapster
//
//  Created by Адиль Медеуев on 15.02.2024.
//

import IQKeyboardManagerSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private lazy var applicationCoordinator: AppCoordinator = {
        guard let navigationController = window?.rootViewController as? UINavigationController else {
            fatalError("rootViewController must be NavigationController")
        }
        return AppCoordinator(router: Router(navigationController: navigationController))
    }()
    
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        IQKeyboardManager.shared.enable = true
        setupNavigation()
        return true
    }
    
    private func setupNavigation() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.makeKeyAndVisible()
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        applicationCoordinator.start()
    }
}
