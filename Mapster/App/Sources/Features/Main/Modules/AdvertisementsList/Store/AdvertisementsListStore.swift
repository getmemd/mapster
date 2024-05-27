//
//  AdvertisementsListStore.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import Factory
import Firebase

enum AdvertisementsListEvent {
    case rows(rows: [AdvertisementsListRows])
    case showError(message: String)
    case loading
    case loadingFinished
    case advertisementSelected(advertisement: Advertisement)
    case advertisementDeleted
    case confirmAdvertisementDeletion(viewState: AdvertisementsListViewState,
                                      completion: (() -> Void))
}

enum AdvertisementsListAction {
    case loadData
    case didSelectRow(row: AdvertisementsListRows)
    case didDeleteRow(index: Int)
}

enum AdvertisementsListViewState {
    case favourites
    case myAdvertisements
}

enum AdvertisementsListRows {
    case title(text: String)
    case advertisement(advertisement: Advertisement)
    case empty(viewState: AdvertisementsListViewState)
}

final class AdvertisementsListStore: Store<AdvertisementsListEvent, AdvertisementsListAction> {
    @Injected(\Repositories.advertisementRepository) private var advertisementRepository
    @Injected(\Repositories.userRepository) private var userRepository
    private let viewState: AdvertisementsListViewState
    private var user: AppUser?
    private var advertisements: [Advertisement] = []
    
    init(viewState: AdvertisementsListViewState) {
        self.viewState = viewState
    }
    
    override func handleAction(_ action: AdvertisementsListAction) {
        switch action {
        case .loadData:
            configureRows()
            getAdvertisements()
        case let .didSelectRow(row):
            switch row {
            case let .advertisement(advertisement):
                sendEvent(.advertisementSelected(advertisement: advertisement))
            default:
                break
            }
        case let .didDeleteRow(index):
            sendEvent(.confirmAdvertisementDeletion(viewState: viewState, completion: { [weak self] in
                self?.deleteAdvertisement(index: index)
            }))
        }
    }
    
    private func getUser() async throws -> AppUser? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return try await userRepository.getUser(uid: uid)
    }
    
    private func getAdvertisements() {
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                sendEvent(.loading)
                switch viewState {
                case .favourites:
                    user = try await getUser()
                    let favouriteAdvertisementsIds = user?.favouriteAdvertisementsIds
                    if let favouriteAdvertisementsIds, !favouriteAdvertisementsIds.isEmpty {
                        advertisements = try await advertisementRepository.getFavouriteAdvertisements(
                            ids: favouriteAdvertisementsIds
                        )
                    }
                case .myAdvertisements:
                    if let uid = Auth.auth().currentUser?.uid {
                        advertisements = try await advertisementRepository.getMyAdvertisements(uid: uid)
                    }
                }
                configureRows()
            } catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
    
    private func deleteAdvertisement(index: Int) {
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                sendEvent(.loading)
                guard let advertisement = advertisements[safe: index] else { return }
                switch viewState {
                case .favourites:
                    editFavourite(id: advertisement.id)
                case .myAdvertisements:
                    try await advertisementRepository.deleteAdvertisement(advertisement: advertisement)
                    advertisements.remove(at: index)
                    sendEvent(.advertisementDeleted)
                    configureRows()
                }
            }
            catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
    
    private func editFavourite(id: String) {
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                sendEvent(.loading)
                if let index = user?.favouriteAdvertisementsIds.firstIndex(of: id) {
                    user?.favouriteAdvertisementsIds.remove(at: index)
                } else {
                    user?.favouriteAdvertisementsIds.append(id)
                }
                guard let user else { return }
                try await userRepository.editFavourites(
                    uid: user.uid,
                    favouriteAdvertisementsIds: user.favouriteAdvertisementsIds
                )
                getAdvertisements()
            }
            catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
    
    private func configureRows() {
        var rows: [AdvertisementsListRows] = [.title(text: viewState == .favourites ? "Избранное" : "Мои объявления")]
        if advertisements.isEmpty {
            rows.append(.empty(viewState: viewState))
        } else {
            rows.append(contentsOf: advertisements.compactMap { .advertisement(advertisement: $0) })
        }
        sendEvent(.rows(rows: rows))
    }
}
