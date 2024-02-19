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
        // В зависимости от текущего состояния представления формируется атрибутированная строка
        switch viewState {
        case .authorization:
            attributedString.mutableString.setString("Запомнить меня")
        case .registration:
            attributedString.mutableString.setString("Я ознакомлен и согласен с условиями использования.")
            // Добавление ссылки в атрибутированную строку
            attributedString.addAttribute(.link,
                                          value: "https://www.apple.com",
                                          range: NSRange(location: 26, length: 23))
        }
        return attributedString
    }
    
    // Свойство для хранения текущего состояния представления
    let viewState: AuthorizationViewController.ViewState
    
    // Инициализатор структуры
    init(viewState: AuthorizationViewController.ViewState) {
        self.viewState = viewState
    }
}

