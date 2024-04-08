//
//  FavouritesTableViewDelegateImpl.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import UIKit

final class FavouritesTableViewDelegateImpl: NSObject {
    var rows: [FavouritesRows] = []
    private let store: FavouritesStore

    init(store: FavouritesStore) {
        self.store = store
    }
}

extension FavouritesTableViewDelegateImpl: UITableViewDelegate {
    // Делегат нажатия на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        store.handleAction(.didSelectRow(row: rows[indexPath.row]))
    }
    
    // Настройка отображения ячейки
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case let .title(text):
            guard let cell = cell as? TitleCell else { return }
            cell.configure(title: text)
        case let .advertisement(advertisement):
            guard let cell = cell as? FavouritesCell else { return }
            cell.configure(with: .init(advertisement: advertisement))
        default:
            break
        }
    }
}
