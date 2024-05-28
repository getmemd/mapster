//
//  HomeStore.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 08.04.2024.
//

import Factory
import CoreLocation

enum HomeEvent {
    case advertisements(viewModels: [HomeAnnotationViewModel])
    case showError(message: String)
    case loading
    case loadingFinished
    case annotationSelected(advertisement: Advertisement)
}

enum HomeAction {
    case loadData
    case didTapAnnotation(index: Int)
}

final class HomeStore: Store<HomeEvent, HomeAction> {
    @Injected(\Repositories.advertisementRepository) private var advertisementRepository
    private var advertisements: [Advertisement] = []
    
    override func handleAction(_ action: HomeAction) {
        switch action {
        case .loadData:
            getAdvertisements()
        case let .didTapAnnotation(index):
            guard let advertisement = advertisements[safe: index] else { return }
            sendEvent(.annotationSelected(advertisement: advertisement))
        }
    }
    
    private func getAdvertisements() {
        sendEvent(.loading)
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                advertisements = try await advertisementRepository.getAdvertisements()
                sendEvent(.advertisements(viewModels: advertisements.compactMap { .init(advertisement: $0) }))
            } catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
}

