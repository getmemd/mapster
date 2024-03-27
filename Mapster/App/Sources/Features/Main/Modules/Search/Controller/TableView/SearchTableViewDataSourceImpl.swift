//
//  SearchTableViewDataSourceImpl.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

final class SearchTableViewDataSourceImpl: NSObject {
    var cellModels: [SearchCellModel] = []
    private let store: SearchStore

    init(store: SearchStore) {
        self.store = store
    }
}

extension SearchTableViewDataSourceImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
