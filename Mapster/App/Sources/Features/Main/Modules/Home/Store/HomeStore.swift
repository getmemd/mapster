//
//  HomeStore.swift
//  Mapster
//
//  Created by User on 08.04.2024.
//

import Factory
import CoreLocation

enum HomeEvent {
    case advertisements(coordinates: [CLLocationCoordinate2D])
    case showError(message: String)
    case loading
    case loadingFinished
}

enum HomeAction {
    case viewDidLoad
}

final class HomeStore: Store<HomeEvent, HomeAction> {
    @Injected(\Repositories.advertisementRepository) private var advertisementRepository
    private var advertisements: [Advertisement] = []
    
    override func handleAction(_ action: HomeAction) {
        switch action {
        case .viewDidLoad:
            getAdvertisements()
        }
    }
    
    private func getAdvertisements() {
        Task {
            do {
                advertisements = try await advertisementRepository.getAdvertisements()
                sendEvent(.advertisements(coordinates: advertisements.compactMap { .init(latitude: $0.geopoint.latitude, longitude: $0.geopoint.longitude) }))
            } catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
}

