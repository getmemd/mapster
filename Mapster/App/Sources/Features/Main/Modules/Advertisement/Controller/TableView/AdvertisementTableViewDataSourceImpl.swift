//
//  AdvertisementTableViewDataSourceImpl.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 09.05.2024.
//

import UIKit

final class AdvertisementTableViewDataSourceImpl: NSObject {
    var rows: [AdvertisementRows] = []
    private let store: AdvertisementStore

    init(store: AdvertisementStore) {
        self.store = store
    }
}

extension AdvertisementTableViewDataSourceImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case let .images(urls):
            let cell: AdvertisementImagesCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(urls: urls)
            return cell
        case let .info(advertisement):
            let cell: AdvertisementInfoCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(with: .init(advertisement: advertisement))
            return cell
        }
    }
}

// MARK: - AdvertisementInfoCellDelegate

extension AdvertisementTableViewDataSourceImpl: AdvertisementInfoCellDelegate {
    func didTapCallByPhone(_ cell: AdvertisementInfoCell) {
        store.handleAction(.callByPhoneDidTap)
    }
    
    func didTapOpenInMap(_ cell: AdvertisementInfoCell, mapType: MapType) {
        store.handleAction(.openInMapDidTap(mapType: mapType))
    }
}
