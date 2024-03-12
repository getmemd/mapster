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
        if isRegistration {
            attributedString.mutableString.setString("Я ознакомлен и согласен с условиями использования.")
            attributedString.addAttribute(.link,
                                          value: "https://www.apple.com",
                                          range: NSRange(location: 26, length: 23))
        } else {
            attributedString.mutableString.setString("Запомнить меня")
        }
        return attributedString
    }
    
    let isRegistration: Bool
    
    init(isRegistration: Bool) {
        self.isRegistration = isRegistration
    }
}
