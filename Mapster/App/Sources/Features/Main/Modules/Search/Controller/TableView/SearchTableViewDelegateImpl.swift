//
//  SearchTableViewDelegateImpl.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

final class SearchTableViewDelegateImpl: NSObject {
    var cellModels: [SearchCellModel] = []
    private let store: SearchStore

    init(store: SearchStore) {
        self.store = store
    }
}

extension SearchTableViewDelegateImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        store.handleAction(.didSelectRow(row: cellModels[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellModel = cellModels[safe: indexPath.row],
              let cell = cell as? TableViewItemCell else { return }
        cell.configure(with: cellModel)
    }
}
