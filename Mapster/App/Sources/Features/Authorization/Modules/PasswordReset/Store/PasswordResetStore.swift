//
//  PasswordResetStore.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 12.03.2024.
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
    @Injected(\Repositories.authRepository) private var authRepository
    
    override func handleAction(_ action: PasswordResetAction) {
        switch action {
        case let .actionButtonDidTap(password):
            updatePassword(password: password)
        }
    }
    
    private func updatePassword(password: String) {
        sendEvent(.loading)
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                try await authRepository.updatePassword(password: password)
                sendEvent(.passwordUpdated)
            } catch {
                sendEvent(.showError(errorMessage: error.localizedDescription))
            }
        }
    }
}
