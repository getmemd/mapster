//
//  CreateStoreDataModel.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 21.05.2024.
//

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
