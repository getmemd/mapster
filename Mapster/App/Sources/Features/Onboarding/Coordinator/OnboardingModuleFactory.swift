//
//  OnboardingModuleFactory.swift
//  Mapster
//
//  Created by User on 17.02.2024.
//

import Foundation

final class OnboardingModuleFactory {
    // Метод для создания экземпляра OnboardingViewController с передачей делегата навигации
    func makeOnboarding(delegate: OnboardingNavigationDelegate) -> OnboardingViewController {
        let viewController = OnboardingViewController()
        viewController.navigationDelegate = delegate // Устанавливаем делегат навигации
        return viewController
    }
}
