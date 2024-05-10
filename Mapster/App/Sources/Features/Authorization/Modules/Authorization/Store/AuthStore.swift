import Factory
import Firebase

enum AuthEvent {
    case showAlert(title: String?, message: String?, completion: ((UIAlertAction) -> Void)? = nil)
    case loading
    case loadingFinished
    case success
}

enum AuthAction {
    case actionButtonDidTap(email: String, password: String, name: String? = nil, phoneNumber: String? = nil)
    case resetPasswordDidTap(email: String)
}

final class AuthStore: Store<AuthEvent, AuthAction> {
    @Injected(\Repositories.authRepository) private var authRepository
    @Injected(\Repositories.userRepository) private var userRepository
    var isRegistration = true
    
    override func handleAction(_ action: AuthAction) {
        switch action {
        case let .actionButtonDidTap(email, password, name, phoneNumber):
            authorization(email: email, password: password, name: name, phoneNumber: phoneNumber)
        case let .resetPasswordDidTap(email):
            sendPasswordReset(email: email)
        }
    }
    
    private func authorization(email: String, password: String, name: String?, phoneNumber: String?) {
        sendEvent(.loading)
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                try await authRepository.authorization(email: email,
                                                       password: password,
                                                       isRegistration: isRegistration)
                if let name {
                    try await updateName(name: name)
                }
                if isRegistration {
                    if let uid = Auth.auth().currentUser?.uid,
                       let phoneNumber {
                        try await userRepository.createUser(user:
                                .init(uid: uid,
                                      phoneNumber: phoneNumber,
                                      favouriteAdvertisements: [])
                        )
                    }
                    try await sendEmailVerifcation()
                } else {
                    sendEvent(.success)
                }
            } catch {
                sendEvent(.showAlert(title: nil, message: error.localizedDescription))
            }
        }
    }
    
    private func updateName(name: String) async throws {
        try await authRepository.updateUser(name: name)
    }
    
    private func sendEmailVerifcation() async throws {
        try await authRepository.sendEmailVerification()
        sendEvent(.showAlert(title: "Подтвердите Вашу почту",
                             message: "На Ваш email было отправлено письмо для подтверждения",
                             completion: { [weak self] _ in
            self?.sendEvent(.success)
        }))
    }
    
    private func sendPasswordReset(email: String) {
        sendEvent(.loading)
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                try await authRepository.sendPasswordResetEmail(email: email)
                sendEvent(.showAlert(title: "Восстановите пароль",
                                     message: "На Ваш email было отправлено письмо для сброса пароля"))
            } catch {
                sendEvent(.showAlert(title: nil, message: error.localizedDescription))
            }
        }
    }
}
