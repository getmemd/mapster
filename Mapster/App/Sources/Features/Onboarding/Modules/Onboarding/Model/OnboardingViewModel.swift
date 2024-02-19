//
//  OnboardingViewModel.swift
//  Mapster
//
//  Created by User on 15.02.2024.
//

import Foundation

struct OnboardingViewModel {
    var title: String {
        switch index {
        case 0:
            return "Создавай задания"
        case 1:
            return "Награды за выполнение"
        case 2:
            return "Будни проще с Mapster"
        default:
            return ""
        }
    }
    
    var description: String {
        switch index {
        case 0:
            return "Или выполняй"
        case 1:
            return "Выполняй и зарабатывай"
        case 2:
            return "Помощь всегда рядом"
        default:
            return ""
        }
    }
    
    var imageName: String {
        switch index {
        case 0:
            return "onboarding1"
        case 1:
            return "onboarding2"
        case 2:
            return "onboarding3"
        default:
            return ""
        }
    }
    
    private let index: Int
    
    init(index: Int) {
        self.index = index
    }
}
