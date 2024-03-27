//
//  FavouritesTableViewDataSourceImpl.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

final class FavouritesTableViewDataSourceImpl: NSObject {
    var rows: [FavouritesRows] = []
    private let store: FavouritesStore

    init(store: FavouritesStore) {
        self.store = store
    }
}

extension FavouritesTableViewDataSourceImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .empty:
            let cell: FavouritesEmptyCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .advertisement:
            let cell: FavouritesCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.handleAction(.didDeleteRow(index: indexPath.row))
            rows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
