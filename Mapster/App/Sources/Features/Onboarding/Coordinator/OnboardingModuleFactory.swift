//
//  OnboardingModuleFactory.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 17.02.2024.
//

import Foundation

final class OnboardingModuleFactory {
    func makeOnboarding(delegate: OnboardingNavigationDelegate) -> OnboardingViewController {
        let viewController = OnboardingViewController()
        viewController.navigationDelegate = delegate
        return viewController
    }
}
