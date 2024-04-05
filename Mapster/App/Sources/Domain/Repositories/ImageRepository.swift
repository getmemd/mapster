//
//  ImageRepository.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 05.04.2024.
//

import Foundation
import FirebaseStorage
import UIKit

final class ImageRepository {
    enum ImageError: Error {
        case invalidImageData
        case unknownError
    }
    
    func uploadImage(_ image: UIImage, to storagePath: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return completion(.failure(ImageError.invalidImageData))
        }
        let storageRef = Storage.storage().reference().child(storagePath)
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                return completion(.failure(error ?? ImageError.unknownError))
            }
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(.success(url))
                } else {
                    completion(.failure(error ?? ImageError.unknownError))
                }
            }
        }
    }
}
