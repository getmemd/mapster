//
//  AdvertisementsListCellModel.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import Foundation

struct AdvertisementsListCellModel {
    var title: String {
        advertisement.name
    }
    
    var priceFormatted: String {
        advertisement.price.formatAsCurrency()
    }
    
    var description: String {
        advertisement.description
    }
    
    var imageUrl: URL? {
        guard let image = advertisement.images.first else { return nil }
        return .init(string: image)
    }
    
    private let advertisement: Advertisement
    
    init(advertisement: Advertisement) {
        self.advertisement = advertisement
    }
}
