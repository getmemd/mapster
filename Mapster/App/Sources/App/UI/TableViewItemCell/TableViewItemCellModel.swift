import Foundation

// Протокол для модели ячейки таблицы
protocol TableViewItemCellModel {
    var iconName: String? { get }
    var title: String? { get }
}

// Расширение протокола для предоставления значения по умолчанию для iconName
extension TableViewItemCellModel {
    var iconName: String? { nil }
}
