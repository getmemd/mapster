import UIKit

// Расширение для UITableView, добавляющее методы для регистрации и получения ячеек и вью
extension UITableView {
    // Метод для регистрации нескольких классов ячеек
    func register(bridgingCellClasses: AnyClass...) {
        bridgingCellClasses.forEach { cell in
            register(bridgingCellClass: cell)
        }
    }

    // Метод для регистрации нескольких классов вью
    func register(bridgingViewClasses: AnyClass...) {
        bridgingViewClasses.forEach { view in
            register(bridgingViewClass: view)
        }
    }

    // Приватный метод для регистрации класса ячеек
    final func register(bridgingCellClass: AnyClass) {
        let reuseIdentifier = String(describing: bridgingCellClass)
        self.register(bridgingCellClass, forCellReuseIdentifier: reuseIdentifier)
    }

    // Приватный метод для регистрации класса вью
    final func register(bridgingViewClass: AnyClass) {
        let reuseIdentifier = String(describing: bridgingViewClass)
        self.register(bridgingViewClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    // Метод для получения ячейки по indexPath
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: "\(Cell.self)", for: indexPath) as? Cell else {
            fatalError("register(cellClass:) has not been implemented")
        }
        return cell
    }
}
