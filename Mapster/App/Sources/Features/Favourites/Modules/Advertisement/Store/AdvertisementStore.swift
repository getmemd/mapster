import Factory
import Firebase
import Foundation

enum AdvertisementEvent {
    case rows(rows: [AdvertisementRows])
    case showError(message: String)
    case loading
    case loadingFinished
    case openInMap(mapType: MapType, latitude: Double, longitude: Double)
    case callByPhone(phoneNumber: String)
    case userLoaded(isFavourite: Bool)
}

enum AdvertisementAction {
    case viewDidLoad
    case openInMapDidTap(mapType: MapType)
    case callByPhoneDidTap
    case favouriteDidTap
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
    @Injected(\Repositories.userRepository) private var userRepository
    private let advertisement: Advertisement
    private var user: AppUser?
    
    init(advertisement: Advertisement) {
        self.advertisement = advertisement
    }
    
    override func handleAction(_ action: AdvertisementAction) {
        switch action {
        case .viewDidLoad:
            getUser()
        case let .openInMapDidTap(mapType):
            sendEvent(.openInMap(mapType: mapType,
                                 latitude: advertisement.geopoint.latitude,
                                 longitude: advertisement.geopoint.longitude))
        case .callByPhoneDidTap:
            sendEvent(.callByPhone(phoneNumber: advertisement.phoneNumber))
        case .favouriteDidTap:
            editFavourite()
        }
    }
    
    private func getUser() {
        Task {
            defer {
                sendEvent(.loadingFinished)
                configureRows()
            }
            do {
                sendEvent(.loading)
                guard let uid = Auth.auth().currentUser?.uid else { return }
                user = try await userRepository.getUser(uid: uid)
                sendEvent(
                    .userLoaded(
                        isFavourite: user?.favouriteAdvertisementsIds.contains(advertisement.id) ?? false
                    )
                )
            } catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
    
    private func editFavourite() {
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                sendEvent(.loading)
                if let index = user?.favouriteAdvertisementsIds.firstIndex(of: advertisement.id) {
                    user?.favouriteAdvertisementsIds.remove(at: index)
                } else {
                    user?.favouriteAdvertisementsIds.append(advertisement.id)
                }
                guard let user else { return }
                try await userRepository.editFavourites(
                    uid: user.uid,
                    favouriteAdvertisementsIds: user.favouriteAdvertisementsIds
                )
                sendEvent(.userLoaded(isFavourite: user.favouriteAdvertisementsIds.contains(advertisement.id)))
            }
            catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
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
