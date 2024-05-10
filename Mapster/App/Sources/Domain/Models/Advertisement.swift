//
//  Advertisement.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import Foundation
import Firebase

struct Advertisement {
    var id: String
    var name: String
    var price: Double
    var category: AdvertisementCategory
    var description: String
    var date: Timestamp
    var geopoint: GeoPoint
    var images: [String]
    var personName: String
    var phoneNumber: String
    var uid: String
    var address: String
    
    init(id: String,
         name: String,
         price: Double,
         category: AdvertisementCategory,
         description: String,
         date: Timestamp,
         geopoint: GeoPoint,
         images: [String],
         personName: String,
         phoneNumber: String,
         uid: String,
         address: String) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.description = description
        self.date = date
        self.geopoint = geopoint
        self.images = images
        self.personName = personName
        self.phoneNumber = phoneNumber
        self.uid = uid
        self.address = address
    }
    
    init?(documentId: String, data: [String: Any]) {
        guard let name = data["name"] as? String,
              let price = data["price"] as? Double,
              let description = data["description"] as? String,
              let date = data["date"] as? Timestamp,
              let geopoint = data["geopoint"] as? GeoPoint,
              let personName = data["personName"] as? String,
              let phoneNumber = data["phoneNumber"] as? String,
              let uid = data["uid"] as? String,
              let address = data["address"] as? String else { return nil }
        self.init(id: documentId,
                  name: name,
                  price: price,
                  category: .init(rawValue: data["category"] as? String ?? "") ?? .other,
                  description: description,
                  date: date,
                  geopoint: geopoint,
                  images: data["images"] as? [String] ?? [],
                  personName: personName,
                  phoneNumber: phoneNumber,
                  uid: uid,
                  address: address)
    }
    
    var dictionary: [String: Any] {
        [
            "id": id,
            "name": name,
            "price": price,
            "category": category.rawValue,
            "description": description,
            "date": date,
            "geopoint": geopoint,
            "images": images,
            "personName": personName,
            "phoneNumber": phoneNumber,
            "uid": uid,
            "address": address
        ]
    }
}
