import FirebaseAuth

// Финальный класс для работы с аутентификацией
final class AuthRepository {
    // Авторизация пользователя (регистрация или вход)
    func authorization(email: String, password: String, isRegistration: Bool) async throws {
        if isRegistration {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } else {
            try await Auth.auth().signIn(withEmail: email, password: password)
        }
    }
    
    // Выход из учетной записи
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // Отправка письма для верификации email
    func sendEmailVerification() async throws {
        try await Auth.auth().currentUser?.sendEmailVerification()
    }
    
    // Обновление пароля пользователя
    func updatePassword(password: String) async throws {
        try await Auth.auth().currentUser?.updatePassword(to: password)
    }
    
    // Отправка письма для сброса пароля
    func sendPasswordResetEmail(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // Обновление имени пользователя
    func updateUser(name: String) async throws {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        try await changeRequest?.commitChanges()
    }
}
