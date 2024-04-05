//
//  TableViewItemCellModel.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import Foundation

// Протокол моделей для настройки ячейки
protocol TableViewItemCellModel {
    var iconName: String? { get }
    var title: String { get }
}

// Переопределение поля протокола для дефолтного значения
extension TableViewItemCellModel {
    var iconName: String? { nil }
}
