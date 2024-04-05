//
//  ProfileStore.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 05.04.2024.
//

import Factory

enum ProfileEvent {
    case rows(rows: [ProfileRows])
    case signOutCompleted
    case showError(message: String)
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
        case let .didSelectRow(row):
            switch row {
            case .signOut:
                signOut()
            default:
                break
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
        sendEvent(.rows(rows: [.editProfile, .policy, .faq, .signOut]))
    }
}
