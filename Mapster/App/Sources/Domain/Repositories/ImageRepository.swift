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
    func uploadImages(imagesData: [Data], completion: @escaping (Result<[URL], Error>) -> Void) {
        let storageRef = Storage.storage().reference()
        let dispatchGroup = DispatchGroup()
        var urls = [URL]()
        var errors = [Error]()

        for imageData in imagesData {
            let imageName = UUID().uuidString
            print(imageName)
            let ref = storageRef.child("images/\(imageName).jpeg")

            dispatchGroup.enter()
            ref.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    errors.append(error)
                    dispatchGroup.leave()
                    return
                }

                ref.downloadURL { url, error in
                    if let error = error {
                        errors.append(error)
                    } else if let url = url {
                        urls.append(url)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            if !errors.isEmpty,
               let error = errors.first {
                completion(.failure(error))
            } else {
                completion(.success(urls))
            }
        }
    }
}
