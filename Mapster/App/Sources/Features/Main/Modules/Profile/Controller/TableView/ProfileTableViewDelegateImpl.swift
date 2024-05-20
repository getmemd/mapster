//
//  ProfileTableViewDelegateImpl.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 05.04.2024.
//

import UIKit

final class ProfileTableViewDelegateImpl: NSObject {
    var rows: [ProfileRows] = []
    private let store: ProfileStore

    init(store: ProfileStore) {
        self.store = store
    }
}

extension ProfileTableViewDelegateImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        store.handleAction(.didSelectRow(row: rows[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case .editProfile, .faq, .policy, .signOut:
            guard let row = rows[safe: indexPath.row],
                  let cell = cell as? TableViewItemCell else { return }
            cell.configure(with: ProfileCellModel(row: row))
        case .info:
            break
        }
    }
}
