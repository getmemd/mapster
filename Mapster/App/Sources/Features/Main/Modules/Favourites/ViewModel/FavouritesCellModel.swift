//
//  FavouritesCellModel.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import Foundation

struct FavouritesCellModel {
    var title: String {
        advertisement.title
    }
    
    var priceFormatted: String {
        advertisement.price.formatAsCurrency()
    }
    
    var description: String {
        advertisement.description
    }
    
    private let advertisement: Advertisement
    
    init(advertisement: Advertisement) {
        self.advertisement = advertisement
    }
}
