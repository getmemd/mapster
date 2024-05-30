import Foundation

protocol TableViewItemCellModel {
    var iconName: String? { get }
    var title: String? { get }
}

extension TableViewItemCellModel {
    var iconName: String? { nil }
}
