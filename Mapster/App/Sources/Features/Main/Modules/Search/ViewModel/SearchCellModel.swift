import Foundation

struct SearchCellModel: TableViewItemCellModel {
    var iconName: String?
    var title: String
    
    init(iconName: String?, title: String) {
        self.iconName = iconName
        self.title = title
    }
}
