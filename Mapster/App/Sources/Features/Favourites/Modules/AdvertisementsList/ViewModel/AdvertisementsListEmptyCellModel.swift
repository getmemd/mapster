import Foundation

struct AdvertisementsListEmptyCellModel {
    var iconName: String {
        switch viewState {
        case .favourites:
            return "favourites-empty"
        case .myAdvertisements:
            return "my-advertisements-empty"
        }
    }
    
    var title: String {
        switch viewState {
        case .favourites:
            return "Нет избранных"
        case .myAdvertisements:
            return "У вас пока нет объявлений"
        }
    }
    
    var subtitle: String {
        switch viewState {
        case .favourites:
            return "Сохраняйте объявления, которые вас заинтересовало, и мы сохраним его здесь."
        case .myAdvertisements:
            return "Создавайте объявления и находите помощь в считанные минуты!"
        }
    }
    
    private let viewState: AdvertisementsListViewState
    
    init(viewState: AdvertisementsListViewState) {
        self.viewState = viewState
    }
}
