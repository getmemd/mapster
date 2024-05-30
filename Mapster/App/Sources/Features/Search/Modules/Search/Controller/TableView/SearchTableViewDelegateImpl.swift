import UIKit

final class SearchTableViewDelegateImpl: NSObject {
    var rows: [SearchRows] = []
    private let store: SearchStore

    init(store: SearchStore) {
        self.store = store
    }
}

extension SearchTableViewDelegateImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        store.handleAction(.didSelectRow(index: indexPath.row))
    }
    
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
