//
//  PasswordResetStore.swift
//  Mapster
//
//  Created by User on 12.03.2024.
//

import Factory

enum PasswordResetEvent {
    case showError(errorMessage: String)
    case loading
    case loadingFinished
    case passwordUpdated
}

enum PasswordResetAction {
    case actionButtonDidTap(password: String)
}

final class PasswordResetStore: Store<PasswordResetEvent, PasswordResetAction> {
    // Введенная зависимость репозитория
    @Injected(\Repositories.authRepository) private var authRepository
    
    // Обработка вызванных экшенов
    override func handleAction(_ action: PasswordResetAction) {
        switch action {
        case let .actionButtonDidTap(password):
            updatePassword(password: password)
        }
    }
    
    // Вызов запроса на обновление пароля
    private func updatePassword(password: String) {
        sendEvent(.loading)
        authRepository.updatePassword(password: password) { [weak self] error in
            if let error {
                self?.sendEvent(.showError(errorMessage: error.localizedDescription))
            }
            self?.sendEvent(.passwordUpdated)
            self?.sendEvent(.loadingFinished)
        }
    }
}
