import Factory
import Firebase

// Финальный класс для работы с объявлениями
final class AdvertisementRepository {
    // Внедрение зависимости базы данных
    @Injected(\.db) private var db
    
    // Получение всех объявлений
    func getAdvertisements() async throws -> [Advertisement] {
        let snapshot = try await db.collection("advertisements").getDocuments()
        return snapshot.documents.compactMap {
            Advertisement(documentId: $0.documentID, data: $0.data())
        }
    }
    
    // Получение объявлений пользователя по UID
    func getMyAdvertisements(uid: String) async throws -> [Advertisement] {
        let ref = db.collection("advertisements")
        let query = ref.whereField("uid", isEqualTo: uid)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap {
            Advertisement(documentId: $0.documentID, data: $0.data())
        }
    }
    
    // Получение избранных объявлений по идентификаторам
    func getFavouriteAdvertisements(ids: [String]) async throws -> [Advertisement] {
        let ref = db.collection("advertisements")
        let query = ref.whereField(FieldPath.documentID(), in: ids)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap {
            Advertisement(documentId: $0.documentID, data: $0.data())
        }
    }
    
    // Получение объявлений по категории
    func advertisementsByCategory(category: AdvertisementCategory) async throws -> [Advertisement] {
        let ref = db.collection("advertisements")
        let query = ref.whereField("category", isEqualTo: category.rawValue)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap {
            Advertisement(documentId: $0.documentID, data: $0.data())
        }
    }
    
    // Создание нового объявления
    func createAdvertisement(advertisement: Advertisement) async throws {
        try await db.collection("advertisements").addDocument(data: advertisement.dictionary)
    }
    
    // Удаление объявления
    func deleteAdvertisement(advertisement: Advertisement) async throws {
        let ref = db.collection("advertisements")
        try await ref.document(advertisement.id).delete()
    }
}
