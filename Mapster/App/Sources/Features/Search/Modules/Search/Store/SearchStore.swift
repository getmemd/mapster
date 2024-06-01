import Factory

// События, отправляемые SearchStore
enum SearchEvent {
    case rows(rows: [SearchRows])
    case loading
    case loadingFinished
    case showError(message: String)
    case didSelectCategory(category: AdvertisementCategory)
    case didSelectAdvertisement(advertisement: Advertisement)
}

// Действия, которые могут быть выполнены в SearchStore
enum SearchAction {
    case viewDidLoad
    case didStartSearch(searchText: String)
    case didSelectRow(index: Int)
}

// Типы строк в таблице поиска
enum SearchRows {
    case title(text: String)
    case row(cellModel: SearchCellModel)
}

// Состояния вида поиска
enum SearchViewState {
    case category
    case advertisements
}

// Хранилище для управления состоянием и действиями поиска
final class SearchStore: Store<SearchEvent, SearchAction> {
    @Injected(\Repositories.advertisementRepository) private var advertisementRepository
    private let viewState: SearchViewState
    private var searchText: String = ""
    private var selectedCategory: AdvertisementCategory?
    private var filteredAdvertisements: [Advertisement] = []
    
    // Инициализация с состоянием вида и выбранной категорией
    init(viewState: SearchViewState, selectedCategory: AdvertisementCategory?) {
        self.viewState = viewState
        self.selectedCategory = selectedCategory
    }
    
    // Обработка действий
    override func handleAction(_ action: SearchAction) {
        switch action {
        case .viewDidLoad:
            switch viewState {
            case .category:
                configureRows()
            case .advertisements:
                getAdvertisementsByCategory()
            }
        case let .didStartSearch(searchText):
            self.searchText = searchText
            configureRows()
        case let .didSelectRow(index):
            switch viewState {
            case .category:
                guard let category = AdvertisementCategory.allCases[safe: index] else { return }
                sendEvent(.didSelectCategory(category: category))
            case .advertisements:
                guard let advertisement = filteredAdvertisements[safe: index - 1] else { return }
                sendEvent(.didSelectAdvertisement(advertisement: advertisement))
            }
        }
    }
    
    // Получение объявлений по категории
    private func getAdvertisementsByCategory() {
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                sendEvent(.loading)
                guard let selectedCategory else { return }
                filteredAdvertisements = try await advertisementRepository.advertisementsByCategory(category: selectedCategory)
                configureRows()
            } catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
    
    // Конфигурация строк таблицы поиска
    private func configureRows() {
        var rows: [SearchRows] = []
        switch viewState {
        case .category:
            rows = AdvertisementCategory.allCases.filter {
                if !searchText.isEmpty {
                    $0.displayName.contains(searchText)
                } else {
                    true
                }
            }.compactMap {
                .row(cellModel: .init(iconName: $0.icon, title: $0.displayName))
            }
        case .advertisements:
            guard let selectedCategory else { return }
            rows = [.title(text: selectedCategory.displayName)]
            rows.append(contentsOf: filteredAdvertisements.filter {
                if !searchText.isEmpty {
                    $0.name.contains(searchText)
                } else {
                    true
                }
            }.compactMap {
                .row(cellModel: .init(iconName: nil, title: $0.name))
            })
        }
        sendEvent(.rows(rows: rows))
    }
}
