//
//  ProfileCellModel.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 05.04.2024.
//

import Foundation

struct ProfileCellModel: TableViewItemCellModel {
    var title: String? {
        switch row {
        case .editProfile:
            return "Редактировать профиль"
        case .myAdvertisements:
            return "Мои объявления"
        case .policy:
            return "Политика конфиденциальности"
        case .faq:
            return "Часто задаваемые вопросы"
        case .signOut:
            return "Выйти"
        default:
            return nil
        }
    }
    
    let row: ProfileRows
    
    init(row: ProfileRows) {
        self.row = row
    }
}
