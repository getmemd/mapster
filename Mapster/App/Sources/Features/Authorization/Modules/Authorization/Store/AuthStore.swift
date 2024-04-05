//
//  AuthStore.swift
//  Mapster
//
//  Created by User on 06.03.2024.
//

import Factory

enum AuthEvent {
    case showAlert(title: String?, message: String?)
    case loading
    case loadingFinished
    case success
}

enum AuthAction {
    case actionButtonDidTap(email: String, password: String)
    case resetPasswordDidTap(email: String)
}

final class AuthStore: Store<AuthEvent, AuthAction> {
    // Введенная зависимость репозитория
    @Injected(\Repositories.authRepository) private var authRepository
    var isRegistration = true
    
    // Обработка вызванных экшенов
    override func handleAction(_ action: AuthAction) {
        switch action {
        case let .actionButtonDidTap(email, password):
            authorization(email: email, password: password)
        case let .resetPasswordDidTap(email):
            sendPasswordReset(email: email)
        }
    }
    
    // Вызов запроса авторизации/уведомления
    private func authorization(email: String, password: String) {
        sendEvent(.loading)
        Task {
            do {
                _ = try await authRepository.authorization(email: email,
                                                           password: password,
                                                           isRegistration: isRegistration)
                if isRegistration {
                    sendEmailVerifcation()
                }
                sendEvent(.success)
                sendEvent(.loadingFinished)
            } catch let error {
                sendEvent(.showAlert(title: nil, message: error.localizedDescription))
                sendEvent(.loadingFinished)
            }
        }
    }
    
    // Вызов запроса отправки подтверждения почты
    private func sendEmailVerifcation() {
        sendEvent(.loading)
        authRepository.sendEmailVerification { [weak self] error in
            if let error {
                self?.sendEvent(.showAlert(title: nil, message: error.localizedDescription))
            }
            self?.sendEvent(.loadingFinished)
            self?.sendEvent(.showAlert(title: "Подтвердите Вашу почту",
                                       message: "На Ваш email было отправлено письмо для подтверждения"))
        }
    }
    
    // Вызов запроса на сброс пароля
    private func sendPasswordReset(email: String) {
        sendEvent(.loading)
        authRepository.sendPasswordResetEmail(email: email) { [weak self] error in
            if let error {
                self?.sendEvent(.showAlert(title: nil, message: error.localizedDescription))
            }
            self?.sendEvent(.loadingFinished)
            self?.sendEvent(.showAlert(title: "Восстановите пароль",
                                       message: "На Ваш email было отправлено письмо для сброса пароля"))
        }
    }
}
