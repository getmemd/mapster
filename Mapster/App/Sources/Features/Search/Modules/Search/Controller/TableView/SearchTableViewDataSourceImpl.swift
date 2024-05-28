//
//  SearchTableViewDataSourceImpl.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

final class SearchTableViewDataSourceImpl: NSObject {
    var rows: [SearchRows] = []
    private let store: SearchStore

    init(store: SearchStore) {
        self.store = store
    }
}

extension SearchTableViewDataSourceImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case let .title(text):
            let cell: TitleCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(title: text)
            return cell
        case .row:
            let cell: TableViewItemCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
}
