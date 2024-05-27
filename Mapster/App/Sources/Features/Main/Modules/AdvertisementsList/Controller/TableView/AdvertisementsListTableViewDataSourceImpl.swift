//
//  AdvertisementsListTableViewDataSourceImpl.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

final class AdvertisementsListTableViewDataSourceImpl: NSObject {
    var rows: [AdvertisementsListRows] = []
    private let store: AdvertisementsListStore

    init(store: AdvertisementsListStore) {
        self.store = store
    }
}

extension AdvertisementsListTableViewDataSourceImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .title:
            let cell: TitleCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case let .empty(viewState):
            let cell: AdvertisementsListEmptyCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: .init(viewState: viewState))
            return cell
        case .advertisement:
            let cell: AdvertisementsListCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.handleAction(.didDeleteRow(index: indexPath.row - 1))
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch rows[indexPath.row] {
        case .advertisement:
            return true
        default:
            return false
        }
    }
}
