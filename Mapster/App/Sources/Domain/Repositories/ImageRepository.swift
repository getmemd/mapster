//
//  ImageRepository.swift
//  Mapster
//
//  Created by User on 05.04.2024.
//

import Foundation
import FirebaseStorage
import UIKit

final class ImageRepository {
    enum ImageError: Error {
        case invalidImageData
        case unknownError
    }
    
    func uploadImage(_ imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("gs://mapster-6fbed.appspot.com")
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
