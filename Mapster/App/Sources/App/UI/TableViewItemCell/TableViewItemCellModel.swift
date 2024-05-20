//
//  TableViewItemCellModel.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import Foundation

protocol TableViewItemCellModel {
    var iconName: String? { get }
    var title: String? { get }
}

extension TableViewItemCellModel {
    var iconName: String? { nil }
}
