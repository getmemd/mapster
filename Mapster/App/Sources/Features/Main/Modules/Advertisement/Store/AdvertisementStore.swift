import Foundation

enum AdvertisementEvent {
    case rows(rows: [AdvertisementRows])
    case openInMap(mapType: MapType, latitude: Double, longitude: Double)
}

enum AdvertisementAction {
    case viewDidLoad
    case openInMapDidTap(mapType: MapType)
}

enum AdvertisementRows {
    case images(urls: [URL])
    case info(advertisement: Advertisement)
}

enum MapType {
    case doubleGis
    case yandexMap
}

final class AdvertisementStore: Store<AdvertisementEvent, AdvertisementAction> {
    private let advertisement: Advertisement
    
    init(advertisement: Advertisement) {
        self.advertisement = advertisement
    }
    
    override func handleAction(_ action: AdvertisementAction) {
        switch action {
        case .viewDidLoad:
            configureRows()
        case let .openInMapDidTap(mapType):
            sendEvent(.openInMap(mapType: mapType,
                                 latitude: advertisement.geopoint.latitude,
                                 longitude: advertisement.geopoint.longitude))
        }
    }
    
    private func configureRows() {
        var rows = [AdvertisementRows]()
        let urls = advertisement.images.compactMap({ URL(string: $0) })
        if !urls.isEmpty {
            rows.append(.images(urls: urls))
        }
        rows.append(.info(advertisement: advertisement))
        sendEvent(.rows(rows: rows))
    }
}
