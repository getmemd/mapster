//
//  FavouritesStore.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import Factory

enum FavouritesEvent {
    case rows(rows: [FavouritesRows])
    case showError(message: String)
    case loading
    case loadingFinished
    case advertisementSelected(advertisement: Advertisement)
}

enum FavouritesAction {
    case loadData
    case didSelectRow(row: FavouritesRows)
    case didDeleteRow(index: Int)
}

enum FavouritesRows {
    case title(text: String)
    case advertisement(advertisement: Advertisement)
    case empty
}

final class FavouritesStore: Store<FavouritesEvent, FavouritesAction> {
    @Injected(\Repositories.advertisementRepository) private var advertisementRepository
    private var advertisements: [Advertisement] = []
    
    override func handleAction(_ action: FavouritesAction) {
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
            advertisements.remove(at: index)
            if advertisements.isEmpty {
                configureRows()
            }    
        }
    }
    
    private func getAdvertisements() {
        sendEvent(.loading)
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                advertisements = try await advertisementRepository.getAdvertisements()
                configureRows()
            } catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
    
    private func configureRows() {
        var rows: [FavouritesRows] = [.title(text: "Избранное")]
        if advertisements.isEmpty {
            rows.append(.empty)
        } else {
            rows.append(contentsOf: advertisements.compactMap { .advertisement(advertisement: $0) })
        }
        sendEvent(.rows(rows: rows))
    }
}
