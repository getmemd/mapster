//
//  CreateStore.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 07.04.2024.
//

import Factory
import Foundation
import Firebase

enum CreateEvent {
    case rows(rows: [CreateRows])
    case showImagePicker
    case showMapPicker
    case showError(message: String)
    case loading
    case loadingFinished
}

enum CreateAction {
    case viewDidLoad
    case didTapAddPhoto
    case didPickedImage(data: Data)
    case didDeleteImage(index: Int)
    case didEndEditing(row: CreateRows, text: String?)
    case didPickedLocation(latitude: Double, longitude: Double)
    case didTapAction
}

enum CreateRows {
    case title(text: String)
    case photos(data: [Data])
    case headline(text: String?)
    case description(text: String?)
    case reward(text: String?)
    case address(text: String?)
    case map(geopoint: GeoPoint?)
}

final class CreateStore: Store<CreateEvent, CreateAction> {
    @Injected(\Repositories.advertisementRepository) private var advertisementRepository
    @Injected(\Repositories.imageRepository) private var imageRepository
    
    private var photos: [Data] = []
    private var imageUrls: [URL] = []
    private var headline: String?
    private var description: String? = "Расскажите о продукте..."
    private var reward: String?
    private var address: String?
    private var geopoint: GeoPoint?
    
    override func handleAction(_ action: CreateAction) {
        switch action {
        case .viewDidLoad:
            configureRows()
        case .didTapAddPhoto:
            sendEvent(.showImagePicker)
        case let .didPickedImage(data):
            photos.append(data)
            configureRows()
        case let .didDeleteImage(index):
            photos.remove(at: index)
            configureRows()
        case let .didEndEditing(row, text):
            switch row {
            case .headline:
                headline = text
            case .description:
                description = text
            case .reward:
                reward = text
            case .address:
                address = text
            default:
                break
            }
        case let .didPickedLocation(latitude, longitude):
            geopoint = .init(latitude: latitude, longitude: longitude)
            configureRows()
        case .didTapAction:
            uploadImages()
        }
    }
    
    private func uploadImages() {
        sendEvent(.loading)
        imageRepository.uploadImages(imagesData: photos) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(urls):
                imageUrls = urls
                if imageUrls.count == photos.count {
                    sendAdvertisement()
                }
            case let .failure(error):
                sendEvent(.showError(message: error.localizedDescription))
                sendEvent(.loadingFinished)
            }
        }
    }
    
    private func sendAdvertisement() {
        Task {
            do {
                guard let headline,
                      let reward,
                      let price = Double(reward),
                      let description,
                      let geopoint,
                      let address,
                      let user = Auth.auth().currentUser else {
                    sendEvent(.showError(message: "Unknown error"))
                    return
                }
                let advertisement = Advertisement(
                  name: headline,
                  price: price,
                  description: description,
                  category: "",
                  date: Date(),
                  geopoint: geopoint,
                  images: imageUrls.compactMap { $0.absoluteString },
                  personName: user.displayName,
                  phoneNumber: user.phoneNumber,
                  address: address)
                try await advertisementRepository.addAdvertisement(advertisement: advertisement)
                sendEvent(.loadingFinished)
            } catch {
                sendEvent(.showError(message: error.localizedDescription))
                sendEvent(.loadingFinished)
            }
        }
    }
    
    private func configureRows() {
        let rows: [CreateRows] = [
            .title(text: "Создать объявление"),
            .photos(data: photos),
            .headline(text: headline),
            .description(text: description),
            .reward(text: reward),
            .address(text: address),
            .map(geopoint: geopoint)
        ]
        sendEvent(.rows(rows: rows))
    }
}