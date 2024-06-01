import Factory
import CoreLocation

// События, отправляемые HomeStore
enum HomeEvent {
    case advertisements(viewModels: [HomeAnnotationViewModel])
    case showError(message: String)
    case loading
    case loadingFinished
    case annotationSelected(advertisement: Advertisement)
    case showCategoryPicker
    case resetFilter
}

// Действия, которые могут быть выполнены в HomeStore
enum HomeAction {
    case loadData
    case didTapAnnotation(index: Int)
    case didSelectCategory(category: AdvertisementCategory)
    case didTapFilter
}

// HomeStore для управления состоянием и действиями
final class HomeStore: Store<HomeEvent, HomeAction> {
    @Injected(\Repositories.advertisementRepository) private var advertisementRepository
    private var advertisements: [Advertisement] = []
    private var selectedCategory: AdvertisementCategory?
    
    // Обработка действий
    override func handleAction(_ action: HomeAction) {
        switch action {
        case .loadData:
            getAdvertisements()
        case let .didTapAnnotation(index):
            guard let advertisement = advertisements[safe: index] else { return }
            sendEvent(.annotationSelected(advertisement: advertisement))
        case let .didSelectCategory(category):
            selectedCategory = category
            configureAnnotations()
        case .didTapFilter:
            if selectedCategory != nil {
                sendEvent(.resetFilter)
                selectedCategory = nil
                configureAnnotations()
            } else {
                sendEvent(.showCategoryPicker)
            }
        }
    }
    
    // Получение объявлений
    private func getAdvertisements() {
        sendEvent(.loading)
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                advertisements = try await advertisementRepository.getAdvertisements()
                configureAnnotations()
            } catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
    
    // Настройка аннотаций на карте
    private func configureAnnotations() {
        var filteredAdvertisements = advertisements
        if selectedCategory != nil {
            filteredAdvertisements = advertisements.filter {
                $0.category == selectedCategory
            }
        }
        sendEvent(.advertisements(viewModels: filteredAdvertisements.compactMap { .init(advertisement: $0) }))
    }
}
