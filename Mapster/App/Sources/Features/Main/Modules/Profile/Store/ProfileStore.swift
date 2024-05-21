//
//  ProfileStore.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 05.04.2024.
//

import Factory
import Firebase

enum ProfileEvent {
    case loading
    case loadingFinished
    case rows(rows: [ProfileRows])
    case signOutCompleted
    case showError(message: String)
    case editProfileTapped
}

enum ProfileAction {
    case loadData
    case didSelectRow(row: ProfileRows)
}

enum ProfileRows {
    case info(name: String?, phoneNumber: String?)
    case editProfile
    case policy
    case faq
    case signOut
}

final class ProfileStore: Store<ProfileEvent, ProfileAction> {
    @Injected(\Repositories.authRepository) private var authRepository
    @Injected(\Repositories.userRepository) private var userRepository
    private var phoneNumber: String?
    
    override func handleAction(_ action: ProfileAction) {
        switch action {
        case .loadData:
            getUser()
        case let .didSelectRow(row):
            switch row {
            case .editProfile:
                sendEvent(.editProfileTapped)
            case .signOut:
                signOut()
            default:
                break
            }
        }
    }
    
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
    
    private func signOut() {
        do {
            try authRepository.signOut()
            sendEvent(.signOutCompleted)
        } catch {
            sendEvent(.showError(message: error.localizedDescription))
        }
    }
    
    private func configureRows() {
        sendEvent(.rows(rows: [.info(name: Auth.auth().currentUser?.displayName,
                                     phoneNumber: phoneNumber),
                               .editProfile,
                               .policy,
                               .faq,
                               .signOut]))
    }
}
