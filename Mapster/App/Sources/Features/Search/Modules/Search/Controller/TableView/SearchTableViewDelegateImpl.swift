import UIKit

// Реализация Delegate для таблицы поиска
final class SearchTableViewDelegateImpl: NSObject {
    var rows: [SearchRows] = []
    private let store: SearchStore

    // Инициализация с хранилищем данных поиска
    init(store: SearchStore) {
        self.store = store
    }
}

// Расширение для реализации протокола UITableViewDelegate
extension SearchTableViewDelegateImpl: UITableViewDelegate {
    
    // Обработка нажатия на строку в таблице
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        store.handleAction(.didSelectRow(index: indexPath.row))
    }
    
    // Настройка ячейки перед её отображением
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case let .row(cellModel):
            guard let cell = cell as? TableViewItemCell else { return }
            cell.configure(with: cellModel)
        default:
            break
        }
    }
}
