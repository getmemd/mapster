//
//  AuthStore.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 06.03.2024.
//

import Factory

enum AuthEvent {
    case showError(errorMessage: String)
    case showAlert(title: String, message: String?)
    case loading
    case loadingFinished
    case success
}

enum AuthAction {
    case actionButtonDidTap(email: String, password: String)
    case resetPasswordDidTap(email: String)
}

final class AuthStore: Store<AuthEvent, AuthAction> {
    @Injected(\Repositories.authRepository) private var authRepository
    var isRegistration = true
    
    override func handleAction(_ action: AuthAction) {
        switch action {
        case let .actionButtonDidTap(email, password):
            authorization(email: email, password: password)
        case let .resetPasswordDidTap(email):
            sendPasswordReset(email: email)
        }
    }
    
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
                sendEvent(.showError(errorMessage: error.localizedDescription))
                sendEvent(.loadingFinished)
            }
        }
    }
    
    private func sendEmailVerifcation() {
        sendEvent(.loading)
        authRepository.sendEmailVerification { [weak self] error in
            if let error {
                self?.sendEvent(.showError(errorMessage: error.localizedDescription))
            }
            self?.sendEvent(.loadingFinished)
            self?.sendEvent(.showAlert(title: "Подтвердите Вашу почту",
                                       message: "На Ваш email было отправлено письмо для подтверждения"))
        }
    }
    
    private func sendPasswordReset(email: String) {
        sendEvent(.loading)
        authRepository.sendPasswordResetEmail(email: email) { [weak self] error in
            if let error {
                self?.sendEvent(.showError(errorMessage: error.localizedDescription))
            }
            self?.sendEvent(.loadingFinished)
            self?.sendEvent(.showAlert(title: "Восстановите пароль",
                                       message: "На Ваш email было отправлено письмо для сброса пароля"))
        }
    }
}
