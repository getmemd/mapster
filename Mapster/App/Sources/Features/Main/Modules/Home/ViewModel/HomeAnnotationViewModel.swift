//
//  HomeAnnotationViewModel.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 10.05.2024.
//

import CoreLocation

struct HomeAnnotationViewModel {
    var coordinates: CLLocationCoordinate2D {
        .init(latitude: advertisement.geopoint.latitude, longitude: advertisement.geopoint.longitude)
    }
    
    var icon: String {
        advertisement.category.icon
    }
    
    var title: String {
        advertisement.name
    }
    
    var subtitle: String {
        advertisement.description
    }
    
    private var advertisement: Advertisement
    
    init(advertisement: Advertisement) {
        self.advertisement = advertisement
    }
}
