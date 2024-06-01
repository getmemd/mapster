import UIKit

// Финальный класс для реализации data source таблицы объявлений
final class AdvertisementTableViewDataSourceImpl: NSObject {
    var rows: [AdvertisementRows] = []
    private let store: AdvertisementStore

    // Инициализация с хранилищем данных
    init(store: AdvertisementStore) {
        self.store = store
    }
}

// Расширение для соответствия протоколу UITableViewDataSource
extension AdvertisementTableViewDataSourceImpl: UITableViewDataSource {
    // Количество строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    // Настройка ячейки для строки
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

// Расширение для обработки делегата ячейки информации объявления
extension AdvertisementTableViewDataSourceImpl: AdvertisementInfoCellDelegate {
    // Обработка нажатия на кнопку звонка
    func didTapCallByPhone(_ cell: AdvertisementInfoCell) {
        store.handleAction(.callByPhoneDidTap)
    }
    
    // Обработка нажатия на кнопку открытия в карте
    func didTapOpenInMap(_ cell: AdvertisementInfoCell, mapType: MapType) {
        store.handleAction(.openInMapDidTap(mapType: mapType))
    }
}
