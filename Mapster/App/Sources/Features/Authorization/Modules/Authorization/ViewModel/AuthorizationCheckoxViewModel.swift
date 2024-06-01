import Foundation

// Модель представления для чекбокса авторизации
struct AuthorizationCheckoxViewModel {
    let isRegistration: Bool
    
    init(isRegistration: Bool) {
        self.isRegistration = isRegistration
    }
}
