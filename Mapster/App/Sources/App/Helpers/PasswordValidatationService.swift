//
//  PasswordValidatationService.swift
//  Mapster
//
//  Created by User on 25.02.2024.
//

import Foundation
import UIKit

// Определение пользовательской ошибки для валидации пароля.
enum PasswordError: LocalizedError {
    case invalid    // Случай, когда пароль невалиден.
    case mismatch   // Случай, когда предоставленные пароли не совпадают.

    // Вычисляемое свойство, предоставляющее описание ошибки.
    var failureReason: String? {
        switch self {
        case .invalid:
            return "Пароль должен содержать минимум 8 символов, хотя бы 1 букву и 1 цифру"
        case .mismatch:
            return "Пароли должны совпадать"
        }
    }
}

// Класс для валидации пароля.
final class PasswordValidatationService {
    // Статическая функция для проверки валидности пароля.
    static func checkPasswordValidity(password: String, repeatPassword: String? = nil) throws {
        // Регулярное выражение для валидации пароля.
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        // NSPredicate для проверки соответствия пароля регулярному выражению.
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        // Проверка пароля на соответствие регулярному выражению.
        if !predicate.evaluate(with: password) {
            // Генерация исключения, если пароль невалиден.
            throw PasswordError.invalid
        }
        // Проверка на совпадение пароля и повторного пароля, если последний предоставлен.
        if let repeatPassword = repeatPassword, password != repeatPassword {
            // Генерация исключения, если пароли не совпадают.
            throw PasswordError.mismatch
        }
    }
}

