import Factory
import Firebase

// События, отправляемые ProfileEditStore
enum ProfileEditEvent {
    case showError(message: String)
    case loading
    case loadingFinished
    case success
}

// Действия, которые могут быть выполнены в ProfileEditStore
enum ProfileEditAction {
    case actionButtonDidTap(name: String?, phoneNumber: String?)
}

// Хранилище для управления состоянием и действиями редактирования профиля
final class ProfileEditStore: Store<ProfileEditEvent, ProfileEditAction> {
    @Injected(\Repositories.authRepository) private var authRepository
    @Injected(\Repositories.userRepository) private var userRepository
    
    // Обработка действий
    override func handleAction(_ action: ProfileEditAction) {
        switch action {
        case let .actionButtonDidTap(name, phoneNumber):
            editPhoneNumber(name: name, phoneNumber: phoneNumber)
        }
    }
    
    // Редактирование номера телефона и имени пользователя
    private func editPhoneNumber(name: String?, phoneNumber: String?) {
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                sendEvent(.loading)
                guard let user = Auth.auth().currentUser else { return }
                if let phoneNumber, !phoneNumber.isEmpty {
                    try await userRepository.editUser(uid: user.uid, phoneNumber: phoneNumber)
                }
                if let name, !name.isEmpty {
                    try await authRepository.updateUser(name: name)
                }
                sendEvent(.success)
            }
            catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
}
