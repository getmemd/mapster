import UIKit

// Реализация DataSource для таблицы профиля
final class ProfileTableViewDataSourceImpl: NSObject {
    var rows: [ProfileRows] = []
    
    private let store: ProfileStore

    // Инициализация с хранилищем данных профиля
    init(store: ProfileStore) {
        self.store = store
    }
}

// Расширение для реализации протокола UITableViewDataSource
extension ProfileTableViewDataSourceImpl: UITableViewDataSource {
    
    // Возвращает количество строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    // Возвращает ячейку для строки на определенном пути
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case let .info(name, phoneNumber):
            let cell: ProfileCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(name: name, phoneNumber: phoneNumber)
            return cell
        case .editProfile, .myAdvertisements, .policy, .signOut:
            let cell: TableViewItemCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
}
