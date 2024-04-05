//
//  Advertisement.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import Foundation
import Firebase

struct Advertisement {
    var name: String
    var price: Double
    var description: String
    var category: String
    var date: Date
    var longitude: Double
    var latitude: Double
    var images: [String]
    var personName: String
    var phoneNumber: String
    var address: String
    
    init(name: String, price: Double, description: String, category: String, date: Date, longitude: Double, latitude: Double, images: [String], personName: String, phoneNumber: String, address: String) {
        self.name = name
        self.price = price
        self.description = description
        self.category = category
        self.date = date
        self.longitude = longitude
        self.latitude = latitude
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
              let longitude = data["longitude"] as? Double,
              let latitude = data["latitude"] as? Double,
              let images = data["images"] as? [String],
              let personName = data["personName"] as? String,
              let phoneNumber = data["phoneNumber"] as? String,
              let address = data["address"] as? String else { return nil }
        self.init(name: name,
                  price: price,
                  description: description,
                  category: category,
                  date: date.dateValue(),
                  longitude: longitude,
                  latitude: latitude,
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
            "longitude": longitude,
            "latitude": latitude,
            "images": images,
            "personName": personName,
            "phoneNumber": phoneNumber,
            "address": address
        ]
    }
}
