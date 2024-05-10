import Foundation

struct AppUser {
    let uid: String
    let phoneNumber: String
    let favouriteAdvertisementsIds: [String]
    
    init(uid: String, phoneNumber: String, favouriteAdvertisements: [String]) {
        self.uid = uid
        self.phoneNumber = phoneNumber
        self.favouriteAdvertisementsIds = favouriteAdvertisements
    }
    
    init?(data: [String: Any]) {
        guard let uid = data["uid"] as? String,
              let phoneNumber = data["phoneNumber"] as? String else { return nil }
        self.init(uid: uid,
                  phoneNumber: phoneNumber,
                  favouriteAdvertisements: data["favouriteAdvertisements"] as? [String] ?? [])
    }
    
    var dictionary: [String: Any] {
        [
            "uid": uid,
            "phoneNumber": phoneNumber,
            "favouriteAdvertisementsIds": favouriteAdvertisementsIds
        ]
    }
}
