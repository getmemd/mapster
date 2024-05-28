//
//  ProfileTableViewDataSourceImpl.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 05.04.2024.
//

import UIKit

final class ProfileTableViewDataSourceImpl: NSObject {
    var rows: [ProfileRows] = []
    
    private let store: ProfileStore

    init(store: ProfileStore) {
        self.store = store
    }
}

extension ProfileTableViewDataSourceImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case let .info(name, phoneNumber):
            let cell: ProfileCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(name: name, phoneNumber: phoneNumber)
            return cell
        case .editProfile, .myAdvertisements, .faq, .policy, .signOut:   
            let cell: TableViewItemCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
}
