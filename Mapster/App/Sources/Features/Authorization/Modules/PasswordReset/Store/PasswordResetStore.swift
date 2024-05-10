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
