//
//  Advertisement.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import Foundation
import Firebase

// Модель объявления
struct Advertisement {
    var name: String
    var price: Double
    var description: String
    var category: String
    var date: Date
    var geopoint: GeoPoint
    var images: [String]
    var personName: String
    var phoneNumber: String
    var address: String
    
    init(name: String, price: Double, description: String, category: String, date: Date, geopoint: GeoPoint, images: [String], personName: String, phoneNumber: String, address: String) {
        self.name = name
        self.price = price
        self.description = description
        self.category = category
        self.date = date
        self.geopoint = geopoint
        self.images = images
        self.personName = personName
        self.phoneNumber = phoneNumber
        self.address = address
    }
    
    init?(data: [String: Any]) {
        guard let name = data["name"] as? String,
              let price = data["price"] as? Double,
              let description = data["description"] as? String,
              let category = data["category"] as? String,
              let date = data["date"] as? Timestamp,
              let geopoint = data["geopoint"] as? GeoPoint,
              let images = data["images"] as? [String],
              let personName = data["personName"] as? String,
              let phoneNumber = data["phoneNumber"] as? String,
              let address = data["address"] as? String else { return nil }
        self.init(name: name,
                  price: price,
                  description: description,
                  category: category,
                  date: date.dateValue(),
                  geopoint: geopoint,
                  images: images,
                  personName: personName,
                  phoneNumber: phoneNumber,
                  address: address)
    }
    
    var dictionary: [String: Any] {
        [
            "name": name,
            "price": price,
            "description": description,
            "category": category,
            "date": date,
            "geopoint": geopoint,
            "images": images,
            "personName": personName,
            "phoneNumber": phoneNumber,
            "address": address
        ]
    }
}
