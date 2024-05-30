import Factory
import Foundation

// Финальный класс для работы с изображениями
final class ImageRepository {
    // Внедрение зависимости хранилища
    @Injected(\.storage) private var storage
    
    // Загрузка изображений и получение их URL
    func uploadImages(imagesData: [Data], completion: @escaping (Result<[URL], Error>) -> Void) {
        let storageRef = storage.reference()
        let dispatchGroup = DispatchGroup()
        var urls = [URL]()
        var errors = [Error]()

        // Цикл для загрузки каждого изображения
        for imageData in imagesData {
            let imageName = UUID().uuidString
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

        // Уведомление о завершении загрузки всех изображений
        dispatchGroup.notify(queue: .main) {
            if !errors.isEmpty, let error = errors.first {
                completion(.failure(error))
            } else {
                completion(.success(urls))
            }
        }
    }
}
