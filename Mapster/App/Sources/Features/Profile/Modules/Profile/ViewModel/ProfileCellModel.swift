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
