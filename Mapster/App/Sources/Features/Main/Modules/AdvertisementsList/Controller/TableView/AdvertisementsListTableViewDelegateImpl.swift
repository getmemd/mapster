//
//  AdvertisementsListTableViewDelegateImpl.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

final class AdvertisementsListTableViewDelegateImpl: NSObject {
    var rows: [AdvertisementsListRows] = []
    private let store: AdvertisementsListStore

    init(store: AdvertisementsListStore) {
        self.store = store
    }
}

extension AdvertisementsListTableViewDelegateImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        store.handleAction(.didSelectRow(row: rows[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case let .advertisement(advertisement):
            guard let cell = cell as? AdvertisementsListCell else { return }
            cell.configure(with: .init(advertisement: advertisement))
        default:
            break
        }
    }
}
