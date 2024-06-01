import UIKit

// Реализация Delegate для таблицы профиля
final class ProfileTableViewDelegateImpl: NSObject {
    var rows: [ProfileRows] = []
    private let store: ProfileStore

    // Инициализация с хранилищем данных профиля
    init(store: ProfileStore) {
        self.store = store
    }
}

// Расширение для реализации протокола UITableViewDelegate
extension ProfileTableViewDelegateImpl: UITableViewDelegate {
    
    // Обработка нажатия на строку в таблице
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        store.handleAction(.didSelectRow(row: rows[indexPath.row]))
    }
    
    // Настройка ячейки перед её отображением
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case .editProfile, .myAdvertisements, .policy, .signOut:
            guard let row = rows[safe: indexPath.row],
                  let cell = cell as? TableViewItemCell else { return }
            cell.configure(with: ProfileCellModel(row: row))
        case .info:
            break
        }
    }
}
