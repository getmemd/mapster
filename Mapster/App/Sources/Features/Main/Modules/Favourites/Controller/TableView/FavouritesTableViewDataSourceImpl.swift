//
//  FavouritesTableViewDataSourceImpl.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import UIKit

final class FavouritesTableViewDataSourceImpl: NSObject {
    // Ряды которые хранят данные
    var rows: [FavouritesRows] = []
    private let store: FavouritesStore

    init(store: FavouritesStore) {
        self.store = store
    }
}

extension FavouritesTableViewDataSourceImpl: UITableViewDataSource {
    // Колличество рядов в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    // Настройка ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .title:
            let cell: TitleCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .empty:
            let cell: FavouritesEmptyCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .advertisement:
            let cell: FavouritesCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    // Удаление ячеек из таблицы
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.handleAction(.didDeleteRow(index: indexPath.row - 1))
            rows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Настройка удаления ячеек из таблицы
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch rows[indexPath.row] {
        case .advertisement:
            return true
        default:
            return false
        }
    }
}
