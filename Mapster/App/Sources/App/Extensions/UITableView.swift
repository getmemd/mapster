//
//  UITableView.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import UIKit

// Вспомогательные функции для TableView
extension UITableView {
    func register(bridgingCellClasses: AnyClass...) {
        bridgingCellClasses.forEach { cell in
            register(bridgingCellClass: cell)
        }
    }

    func register(bridgingViewClasses: AnyClass...) {
        bridgingViewClasses.forEach { view in
            register(bridgingViewClass: view)
        }
    }

    final func register(bridgingCellClass: AnyClass) {
        let reuseIdentifier = String(describing: bridgingCellClass)
        self.register(bridgingCellClass, forCellReuseIdentifier: reuseIdentifier)
    }

    final func register(bridgingViewClass: AnyClass) {
        let reuseIdentifier = String(describing: bridgingViewClass)
        self.register(bridgingViewClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: "\(Cell.self)", for: indexPath) as? Cell else {
            fatalError("register(cellClass:) has not been implemented")
        }
        return cell
    }
}
