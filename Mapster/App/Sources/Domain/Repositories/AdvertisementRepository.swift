import Factory
import Foundation

final class AdvertisementRepository {
    @Injected(\.db) private var db
    
    func getAdvertisements() async throws -> [Advertisement] {
        let snapshot = try await db.collection("advertisements").getDocuments()
        return snapshot.documents.compactMap {
            Advertisement(documentId: $0.documentID, data: $0.data())
        }
    }
    
    func createAdvertisement(advertisement: Advertisement) async throws {
        let ref = try await db.collection("advertisements").addDocument(data: advertisement.dictionary)
        print("Advertisement successfully added with ID: \(ref.documentID)")
    }
}
