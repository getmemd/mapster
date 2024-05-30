import Foundation
import UIKit

// Перечисление ошибок для паролей
enum PasswordError: LocalizedError {
    // Некорректный пароль
    case invalid
    // Пароли не совпадают
    case mismatch
    
    // Описание причин ошибки
    var failureReason: String? {
        switch self {
        case .invalid:
            return "Пароль должен содержать минимум 8 символов, хотя бы 1 букву и 1 цифру"
        case .mismatch:
            return "Пароли должны совпадать"
        }
    }
}

// Сервис валидации
final class ValidationService {
    // Проверка корректности пароля
    static func checkPasswordValidity(password: String, repeatPassword: String? = nil) throws {
        // Регулярное выражение для проверки пароля
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        // Проверка пароля
        if !predicate.evaluate(with: password) {
            throw PasswordError.invalid
        }
        // Проверка совпадения паролей
        if let repeatPassword, password != repeatPassword {
            throw PasswordError.mismatch
        }
    }
    
    // Проверка корректности номера телефона
    static func checkPhoneNumberValidity(phoneNumber: String?) -> Bool {
        // Удаление всех нецифровых символов
        let numericPhoneNumber = phoneNumber?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        // Регулярное выражение для проверки номера телефона
        let phoneNumberRegex = "^[0-9]{11}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        // Проверка номера телефона
        return predicate.evaluate(with: numericPhoneNumber)
    }
}
