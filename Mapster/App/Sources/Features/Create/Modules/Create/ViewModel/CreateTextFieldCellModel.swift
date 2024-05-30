import UIKit

struct CreateTextFieldCellModel {
    var title: String? {
        switch rowType {
        case .headline:
            return "Заголовок объявления"
        case .reward:
            return "Вознаграждение"
        case .address:
            return "Адрес"
        case .category:
            return "Категория"
        default:
            return nil
        }
    }
    
    var placeholder: String? {
        switch rowType {
        case .headline:
            return "Например: iPhone 11 с гарантией"
        case .reward:
            return "Тенге"
        case .address:
            return "Улица, дом"
        default:
            return nil
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch rowType {
        case .reward:
            return .decimalPad
        default:
            return .default
        }
    }
    
    let rowType: CreateRows
    let value: String?
    
    init(rowType: CreateRows, value: String?) {
        self.rowType = rowType
        self.value = value
    }
}
