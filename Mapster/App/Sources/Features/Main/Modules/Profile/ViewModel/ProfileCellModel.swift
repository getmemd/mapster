import Foundation

struct ProfileCellModel: TableViewItemCellModel {
    var title: String {
        switch row {
        case .editProfile:
            return "Редактировать профиль"
        case .policy:
            return "Политика конфиденциальности"
        case .faq:
            return "Часто задаваемые вопросы"
        case .signOut:
            return "Выйти"
        }
    }
    
    let row: ProfileRows
    
    init(row: ProfileRows) {
        self.row = row
    }
}
