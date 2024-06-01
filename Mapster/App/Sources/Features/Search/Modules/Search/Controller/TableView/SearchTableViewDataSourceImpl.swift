import UIKit

// Реализация DataSource для таблицы поиска
final class SearchTableViewDataSourceImpl: NSObject {
    var rows: [SearchRows] = []
    private let store: SearchStore

    // Инициализация с хранилищем данных поиска
    init(store: SearchStore) {
        self.store = store
    }
}

// Расширение для реализации протокола UITableViewDataSource
extension SearchTableViewDataSourceImpl: UITableViewDataSource {
    
    // Возвращает количество строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    // Возвращает ячейку для строки на определенном пути
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
