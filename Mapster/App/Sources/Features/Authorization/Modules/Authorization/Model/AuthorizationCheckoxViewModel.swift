//
//  AuthorizationCheckoxViewModel.swift
//  Mapster
//
//  Created by User on 19.02.2024.
//

import Foundation

struct AuthorizationCheckoxViewModel {
    // Переменная для получения атрибутированной строки в зависимости от текущего состояния представления
    var attributedString: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        if isRegistration {
            attributedString.mutableString.setString("Я ознакомлен и согласен с условиями использования.")
            // Добавление ссылки в атрибутированную строку
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

