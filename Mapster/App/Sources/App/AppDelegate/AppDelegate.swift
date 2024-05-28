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
    private var applicationCoordinator: AppCoordinator?
    
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
        let navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        applicationCoordinator = AppCoordinator(router: .init(navigationController: navigationController))
        applicationCoordinator?.start()
    }
}
