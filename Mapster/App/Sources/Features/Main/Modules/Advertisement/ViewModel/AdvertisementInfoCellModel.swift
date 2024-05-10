//
//  AdvertisementInfoCellModel.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 09.05.2024.
//

import Foundation

struct AdvertisementInfoCellModel {
    var date: String {
        advertisement.date.dateValue().formatted(date: .abbreviated, time: .standard)
    }
    
    var price: String {
        advertisement.price.formatAsCurrency()
    }
    
    var title: String {
        advertisement.name
    }
    
    var category: String {
        advertisement.category.displayName
    }
    
    var description: String {
        advertisement.description
    }
    
    var personName: String? {
        advertisement.personName
    }
    
    var phoneNumber: String? {
        advertisement.phoneNumber
    }
    
    var address: String {
        advertisement.address
    }
    
    private let advertisement: Advertisement
    
    init(advertisement: Advertisement) {
        self.advertisement = advertisement
    }
}
