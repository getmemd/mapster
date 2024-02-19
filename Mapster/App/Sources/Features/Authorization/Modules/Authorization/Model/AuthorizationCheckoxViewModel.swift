//
//  AuthorizationCheckoxViewModel.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 19.02.2024.
//

import Foundation

struct AuthorizationCheckoxViewModel {
    var attributedString: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        switch viewState {
        case .authorization:
            attributedString.mutableString.setString("Запомнить меня")
        case .registration:
            attributedString.mutableString.setString("Я ознакомлен и согласен с условиями использования.")
            attributedString.addAttribute(.link,
                                          value: "https://www.apple.com",
                                          range: NSRange(location: 26, length: 23))
        }
        return attributedString
    }
    
    let viewState: AuthorizationViewController.ViewState
    
    init(viewState: AuthorizationViewController.ViewState) {
        self.viewState = viewState
    }
}
