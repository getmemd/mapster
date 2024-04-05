//
//  SearchTableViewDataSourceImpl.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import UIKit

final class SearchTableViewDataSourceImpl: NSObject {
    // Модели для ячеек
    var cellModels: [SearchCellModel] = []
    private let store: SearchStore

    init(store: SearchStore) {
        self.store = store
    }
}

extension SearchTableViewDataSourceImpl: UITableViewDataSource {
    // Колличество рядов в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }
    
    // Настройка ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewItemCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
