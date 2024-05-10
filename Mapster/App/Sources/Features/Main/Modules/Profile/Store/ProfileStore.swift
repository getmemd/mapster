import Factory
import Firebase

enum ProfileEvent {
    case rows(rows: [ProfileRows])
    case signOutCompleted
    case showError(message: String)
    case profileLoaded(name: String)
}

enum ProfileAction {
    case viewDidLoad
    case didSelectRow(row: ProfileRows)
}

enum ProfileRows {
    case editProfile
    case policy
    case faq
    case signOut
}

final class ProfileStore: Store<ProfileEvent, ProfileAction> {
    @Injected(\Repositories.authRepository) private var authRepository
    
    override func handleAction(_ action: ProfileAction) {
        switch action {
        case .viewDidLoad:
            configureRows()
            if let name = Auth.auth().currentUser?.displayName {
                sendEvent(.profileLoaded(name: name))
            }
        case let .didSelectRow(row):
            switch row {
            case .signOut:
                signOut()
            default:
                break
            }
        }
    }
    
    // Запрос выхода
    private func signOut() {
        do {
            try authRepository.signOut()
            sendEvent(.signOutCompleted)
        } catch {
            sendEvent(.showError(message: error.localizedDescription))
        }
    }
    
    // Настройка данных для таблицы
    private func configureRows() {
        sendEvent(.rows(rows: [.editProfile, .policy, .faq, .signOut]))
    }
}
