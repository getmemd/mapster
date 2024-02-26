//
//  PasswordValidator.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 25.02.2024.
//

import Foundation
import UIKit

enum PasswordError: LocalizedError {
    case invalid
    case mismatch
    
    var failureReason: String? {
        switch self {
        case .invalid:
            return "Пароль должен содержать минимум 8 символов, хотя бы 1 букву и 1 цифру"
        case .mismatch:
            return "Пароли должны совпадать"
        }
    }
}

final class PasswordValidator {
    static func checkPasswordValidity(password: String, repeatPassword: String? = nil) throws {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if !predicate.evaluate(with: password) {
            throw PasswordError.invalid
        }
        if let repeatPassword, password != repeatPassword {
            throw PasswordError.mismatch
        }
    }
}
