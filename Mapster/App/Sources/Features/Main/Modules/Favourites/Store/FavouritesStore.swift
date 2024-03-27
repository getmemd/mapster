//
//  FavouritesStore.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import Foundation

enum FavouritesEvent {
    case rows(rows: [FavouritesRows])
}

enum FavouritesAction {
    case viewDidLoad
    case didSelectRow(row: FavouritesRows)
    case didDeleteRow(index: Int)
}

enum FavouritesRows {
    case advertisement(advertisement: Advertisement)
    case empty
}

final class FavouritesStore: Store<FavouritesEvent, FavouritesAction> {
    private var advertisements: [Advertisement] = []
    
    override func handleAction(_ action: FavouritesAction) {
        switch action {
        case .viewDidLoad:
            advertisements = []
            configureRows()
        case let .didSelectRow(row):
            break
        case let .didDeleteRow(index):
            advertisements.remove(at: index)
            if advertisements.isEmpty {
                configureRows()
            }
        }
    }
    
    // Настройка данных для таблицы
    private func configureRows() {
        var rows: [FavouritesRows] = []
        if advertisements.isEmpty {
            rows.append(.empty)
        } else {
            rows.append(contentsOf: advertisements.compactMap { .advertisement(advertisement: $0) })
        }
        sendEvent(.rows(rows: rows))
    }
}
