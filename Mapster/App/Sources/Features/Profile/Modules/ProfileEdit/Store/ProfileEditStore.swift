import Factory
import Firebase

enum ProfileEditEvent {
    case showError(message: String)
    case loading
    case loadingFinished
    case success
}

enum ProfileEditAction {
    case actionButtonDidTap(name: String?, phoneNumber: String?)
}

final class ProfileEditStore: Store<ProfileEditEvent, ProfileEditAction> {
    @Injected(\Repositories.authRepository) private var authRepository
    @Injected(\Repositories.userRepository) private var userRepository
    
    override func handleAction(_ action: ProfileEditAction) {
        switch action {
        case let .actionButtonDidTap(name, phoneNumber):
            editPhoneNumber(name: name, phoneNumber: phoneNumber)
        }
    }
    
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
