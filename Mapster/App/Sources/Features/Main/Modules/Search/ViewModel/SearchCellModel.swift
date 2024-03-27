//
//  SearchCellModel.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import Foundation

struct SearchCellModel {
    var iconName: String?
    var title: String
    
    init(iconName: String?, title: String) {
        self.iconName = iconName
        self.title = title
    }
}
