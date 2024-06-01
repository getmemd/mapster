import Factory
import Firebase

// События профиля, отправляемые ProfileStore
enum ProfileEvent {
    case loading
    case loadingFinished
    case rows(rows: [ProfileRows])
    case signOutCompleted
    case showError(message: String)
    case rowTapped(row: ProfileRows)
}

// Действия, которые могут быть выполнены в ProfileStore
enum ProfileAction {
    case loadData
    case didSelectRow(row: ProfileRows)
}

// Типы строк в таблице профиля
enum ProfileRows {
    case info(name: String?, phoneNumber: String?)
    case editProfile
    case myAdvertisements
    case policy
    case signOut
}

// Хранилище для управления состоянием и действиями профиля
final class ProfileStore: Store<ProfileEvent, ProfileAction> {
    @Injected(\Repositories.authRepository) private var authRepository
    @Injected(\Repositories.userRepository) private var userRepository
    private var phoneNumber: String?
    
    // Обработка действий
    override func handleAction(_ action: ProfileAction) {
        switch action {
        case .loadData:
            getUser()
        case let .didSelectRow(row):
            switch row {
            case .signOut:
                signOut()
            default:
                sendEvent(.rowTapped(row: row))
            }
        }
    }
    
    // Получение данных пользователя
    private func getUser() {
        Task {
            defer {
                sendEvent(.loadingFinished)
                configureRows()
            }
            do {
                sendEvent(.loading)
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let user = try await userRepository.getUser(uid: uid)
                phoneNumber = user.phoneNumber
            } catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
    
    // Выход из аккаунта
    private func signOut() {
        do {
            try authRepository.signOut()
            sendEvent(.signOutCompleted)
        } catch {
            sendEvent(.showError(message: error.localizedDescription))
        }
    }
    
    // Конфигурация строк таблицы профиля
    private func configureRows() {
        sendEvent(.rows(rows: [.info(name: Auth.auth().currentUser?.displayName,
                                     phoneNumber: phoneNumber),
                               .editProfile,
                               .myAdvertisements,
                               .policy,
                               .signOut]))
    }
}
