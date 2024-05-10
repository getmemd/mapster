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
    case didPickImage(data: Data)
    case didDeleteImage(index: Int)
    case didEndEditing(row: CreateRows, text: String?)
    case didPickLocation(latitude: Double, longitude: Double)
    case didTapAction
    case didPickCategory(category: AdvertisementCategory)
}

enum CreateRows {
    case title(text: String)
    case photos(data: [Data])
    case headline(text: String?)
    case category(category: AdvertisementCategory)
    case description(text: String?)
    case reward(text: String?)
    case address(text: String?)
    case map(geopoint: GeoPoint?)
}

final class CreateStore: Store<CreateEvent, CreateAction> {
    @Injected(\Repositories.advertisementRepository) private var advertisementRepository
    @Injected(\Repositories.imageRepository) private var imageRepository
    @Injected(\Repositories.userRepository) private var userRepository
    
    private var photos: [Data] = []
    private var imageUrls: [URL] = []
    private var headline: String?
    private var category: AdvertisementCategory = .other
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
        case let .didPickImage(data):
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
        case let .didPickLocation(latitude, longitude):
            geopoint = .init(latitude: latitude, longitude: longitude)
            configureRows()
        case .didTapAction:
            uploadImages()
        case let .didPickCategory(category):
            self.category = category
        }
    }
    
    private func uploadImages() {
        sendEvent(.loading)
        imageRepository.uploadImages(imagesData: photos) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(urls):
                imageUrls = urls
                getUser()
            case let .failure(error):
                sendEvent(.showError(message: error.localizedDescription))
                sendEvent(.loadingFinished)
            }
        }
    }
    
    private func getUser() {
        Task {
            defer {
                sendEvent(.loadingFinished)
            }
            do {
                guard let uid = Auth.auth().currentUser?.uid else {
                    sendEvent(.showError(message: "Unknown error"))
                    return
                }
                let user = try await userRepository.getUser(uid: uid)
                try await sendAdvertisement(user: user)
            } catch {
                sendEvent(.showError(message: error.localizedDescription))
            }
        }
    }
    
    private func sendAdvertisement(user: AppUser) async throws {
        guard let headline,
              let reward,
              let price = Double(reward),
              let description,
              let geopoint,
              let address,
              let personName = Auth.auth().currentUser?.displayName else {
            throw NSError(domain: "UnknownError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
        }
        let advertisement = Advertisement(
            id: "mock",
            name: headline,
            price: price,
            category: category,
            description: description,
            date: Timestamp(date: Date()),
            geopoint: geopoint,
            images: imageUrls.compactMap { $0.absoluteString },
            personName: personName,
            phoneNumber: user.phoneNumber,
            uid: user.uid,
            address: address
        )
        try await advertisementRepository.createAdvertisement(advertisement: advertisement)
    }
    
    private func configureRows() {
        let rows: [CreateRows] = [
            .title(text: "Создать объявление"),
            .photos(data: photos),
            .headline(text: headline),
            .category(category: category),
            .description(text: description),
            .reward(text: reward),
            .address(text: address),
            .map(geopoint: geopoint)
        ]
        sendEvent(.rows(rows: rows))
    }
}
