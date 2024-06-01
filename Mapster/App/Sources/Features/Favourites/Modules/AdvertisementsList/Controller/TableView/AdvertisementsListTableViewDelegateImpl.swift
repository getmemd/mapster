import UIKit

// Финальный класс для реализации делегата таблицы списка объявлений
final class AdvertisementsListTableViewDelegateImpl: NSObject {
    var rows: [AdvertisementsListRows] = []
    private let store: AdvertisementsListStore

    // Инициализация с хранилищем
    init(store: AdvertisementsListStore) {
        self.store = store
    }
}

// Расширение для реализации методов делегата таблицы
extension AdvertisementsListTableViewDelegateImpl: UITableViewDelegate {
    // Метод вызывается при выборе строки в таблице
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        store.handleAction(.didSelectRow(row: rows[indexPath.row]))
    }
    
    // Метод вызывается перед отображением ячейки
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
