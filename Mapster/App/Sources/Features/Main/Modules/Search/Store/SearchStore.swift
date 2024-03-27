//
//  SearchStore.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import Foundation

enum SearchEvent {
    case rows(cellModels: [SearchCellModel])
}

enum SearchAction {
    case viewDidLoad
}

final class SearchStore: Store<SearchEvent, SearchAction> {
    override func handleAction(_ action: SearchAction) {
        switch action {
        case .viewDidLoad:
            configureRows()
        }
    }
    
    // Настройка данных для таблицы
    private func configureRows() {
        let cellModels: [SearchCellModel] = [
            .init(iconName: "wrench.and.screwdriver.fill", title: "Сантехника"),
            .init(iconName: "sofa.fill", title: "Текстиль"),
            .init(iconName: "car.fill", title: "Транспорт")
        ]
        sendEvent(.rows(cellModels: cellModels))
    }
}
