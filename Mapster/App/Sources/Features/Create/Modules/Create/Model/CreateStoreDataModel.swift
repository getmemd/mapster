import Firebase
import Foundation

struct CreateStoreDataModel {
    var photos: [Data] = []
    var imageUrls: [URL] = []
    var headline: String?
    var category: AdvertisementCategory = .other
    var description: String?
    var reward: String?
    var address: String?
    var geopoint: GeoPoint?
}
