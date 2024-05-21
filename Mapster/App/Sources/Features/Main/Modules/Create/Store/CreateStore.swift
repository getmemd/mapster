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
    case success
    case showError(message: String)
    case showToast(message: String)
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
    
    private var data: CreateStoreDataModel = .init()
    
    override func handleAction(_ action: CreateAction) {
        switch action {
        case .viewDidLoad:
            sendEvent(.showToast(message: "Тестовый тост"))
            configureRows()
        case .didTapAddPhoto:
            sendEvent(.showImagePicker)
        case let .didPickImage(data):
            self.data.photos.append(data)
            configureRows()
        case let .didDeleteImage(index):
            data.photos.remove(at: index)
            configureRows()
        case let .didEndEditing(row, text):
            switch row {
            case .headline:
                data.headline = text
            case .description:
                data.description = text
            case .reward:
                data.reward = text
            case .address:
                data.address = text
            default:
                break
            }
        case let .didPickLocation(latitude, longitude):
            data.geopoint = .init(latitude: latitude, longitude: longitude)
            configureRows()
        case .didTapAction:
            uploadImages()
        case let .didPickCategory(category):
            data.category = category
        }
    }
    
    private func uploadImages() {
        sendEvent(.loading)
        imageRepository.uploadImages(imagesData: data.photos) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(urls):
                data.imageUrls = urls
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
        guard let headline = data.headline,
              let reward = data.reward,
              let price = Double(reward),
              let description = data.description,
              let geopoint = data.geopoint,
              let address = data.address,
              let personName = Auth.auth().currentUser?.displayName else {
            throw NSError(domain: "UnknownError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
        }
        let advertisement = Advertisement(
            id: "mock",
            name: headline,
            price: price,
            category: data.category,
            description: description,
            date: Timestamp(date: Date()),
            geopoint: geopoint,
            images: data.imageUrls.compactMap { $0.absoluteString },
            personName: personName,
            phoneNumber: user.phoneNumber,
            uid: user.uid,
            address: address
        )
        try await advertisementRepository.createAdvertisement(advertisement: advertisement)
        sendEvent(.showToast(message: "Успешно"))
        sendEvent(.success)
        data = .init()
        configureRows()
    }
    
    private func configureRows() {
        let rows: [CreateRows] = [
            .title(text: "Создать объявление"),
            .photos(data: data.photos),
            .headline(text: data.headline),
            .category(category: data.category),
            .description(text: data.description),
            .reward(text: data.reward),
            .address(text: data.address),
            .map(geopoint: data.geopoint)
        ]
        sendEvent(.rows(rows: rows))
    }
}
