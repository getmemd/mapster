import UIKit

final class CreateTableViewDataSourceImpl: NSObject {
    var tableView: UITableView?
    var rows: [CreateRows] = []
    
    private let store: CreateStore

    init(store: CreateStore) {
        self.store = store
    }
}

extension CreateTableViewDataSourceImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case let .title(text):
            let cell: TitleCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(title: text)
            return cell
        case let .photos(data):
            let cell: CreatePhotoCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(images: data)
            return cell
        case let .headline(text),
            let .reward(text),
            let .address(text):
            let cell: CreateTextFieldCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(with: .init(rowType: rows[indexPath.row], value: text))
            return cell
        case let .category(category):
            let cell: CreateDropDownCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(with: .init(rowType: .category(category: category), value: category.displayName))
            return cell
        case let .description(text):
            let cell: CreateTextViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(text: text)
            return cell
        case let .map(geopoint):
            let cell: CreateMapCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(geopoint: geopoint)
            return cell
        }
    }
}

// MARK: - CreatePhotoCellDelegate

extension CreateTableViewDataSourceImpl: CreatePhotoCellDelegate {
    func didTapAddPhoto(_ cell: CreatePhotoCell) {
        store.handleAction(.didTapAddPhoto)
    }
    
    func didDeleteImage(_ cell: CreatePhotoCell, index: Int) {
        store.handleAction(.didDeleteImage(index: index))
    }
}

// MARK: - CreateTextFieldCellDelegate

extension CreateTableViewDataSourceImpl: CreateTextFieldCellDelegate {
    func didEndEditing(_ cell: CreateTextFieldCell, text: String?) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        store.handleAction(.didEndEditing(row: rows[indexPath.row], text: text))
    }
}

// MARK: - CreateTextViewCellDelegate

extension CreateTableViewDataSourceImpl: CreateTextViewCellDelegate {
    func didEndEditing(_ cell: CreateTextViewCell, text: String?) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        store.handleAction(.didEndEditing(row: rows[indexPath.row], text: text))
    }
}

// MARK: - CreateMapCellDelegate

extension CreateTableViewDataSourceImpl: CreateMapCellDelegate {
    func didTapMap(_ cell: CreateMapCell) {
        store.sendEvent(.showMapPicker)
    }
    
    func didTapActionButton(_ cell: CreateMapCell) {
        store.handleAction(.didTapAction)
    }
}

// MARK: - CreateDropDownCellDelegate

extension CreateTableViewDataSourceImpl: CreateDropDownCellDelegate {
    func didSelectCategory(_ cell: CreateDropDownCell, category: AdvertisementCategory) {
        store.handleAction(.didPickCategory(category: category))
    }
}
