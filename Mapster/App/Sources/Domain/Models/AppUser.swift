//
//  AppUser.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 09.05.2024.
//

import Foundation

struct AppUser {
    let uid: String
    let phoneNumber: String
    var favouriteAdvertisementsIds: [String]
    
    init(uid: String, phoneNumber: String, favouriteAdvertisementsIds: [String]) {
        self.uid = uid
        self.phoneNumber = phoneNumber
        self.favouriteAdvertisementsIds = favouriteAdvertisementsIds
    }
    
    init?(data: [String: Any]) {
        guard let uid = data["uid"] as? String,
              let phoneNumber = data["phoneNumber"] as? String else { return nil }
        self.init(uid: uid,
                  phoneNumber: phoneNumber,
                  favouriteAdvertisementsIds: data["favouriteAdvertisementsIds"] as? [String] ?? [])
    }
    
    var dictionary: [String: Any] {
        [
            "uid": uid,
            "phoneNumber": phoneNumber,
            "favouriteAdvertisementsIds": favouriteAdvertisementsIds
        ]
    }
}
