import UIKit

// Финальный класс для реализации data source таблицы списка объявлений
final class AdvertisementsListTableViewDataSourceImpl: NSObject {
    var rows: [AdvertisementsListRows] = []
    private let store: AdvertisementsListStore

    // Инициализация с хранилищем
    init(store: AdvertisementsListStore) {
        self.store = store
    }
}

// Расширение для реализации методов data source таблицы
extension AdvertisementsListTableViewDataSourceImpl: UITableViewDataSource {
    // Метод для получения количества строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    // Метод для конфигурации ячеек таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case let .title(text):
            let cell: TitleCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(title: text)
            return cell
        case let .empty(viewState):
            let cell: AdvertisementsListEmptyCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: .init(viewState: viewState))
            return cell
        case .advertisement:
            let cell: AdvertisementsListCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    // Метод для удаления строки из таблицы
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.handleAction(.didDeleteRow(index: indexPath.row - 1))
        }
    }
    
    // Метод для проверки возможности редактирования строки
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch rows[indexPath.row] {
        case .advertisement:
            return true
        default:
            return false
        }
    }
}
