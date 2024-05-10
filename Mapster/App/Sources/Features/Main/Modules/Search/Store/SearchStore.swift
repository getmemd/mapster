import Foundation

enum SearchEvent {
    case rows(cellModels: [SearchCellModel])
}

enum SearchAction {
    case viewDidLoad
    case searchDidStart(searchText: String)
}

final class SearchStore: Store<SearchEvent, SearchAction> {
    var searchText: String = ""
    
    override func handleAction(_ action: SearchAction) {
        switch action {
        case .viewDidLoad:
            configureRows()
        case let .searchDidStart(searchText):
            self.searchText = searchText
            configureRows()
        }
    }
    
    // Настройка данных для таблицы
    private func configureRows() {
        let cellModels: [SearchCellModel] = AdvertisementCategory.allCases.filter {
            if !searchText.isEmpty {
                $0.displayName.contains(searchText)
            } else {
                true
            }
        }.compactMap {
            SearchCellModel(iconName: $0.icon, title: $0.displayName)
        }
        sendEvent(.rows(cellModels: cellModels))
    }
}
