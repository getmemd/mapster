//
//  AdvertisementRepository.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 01.04.2024.
//

import Factory
import Firebase

final class AdvertisementRepository {
    @Injected(\.db) private var db
    
    func getAdvertisements() async throws -> [Advertisement] {
        let snapshot = try await db.collection("advertisements").getDocuments()
        return snapshot.documents.compactMap {
            Advertisement(documentId: $0.documentID, data: $0.data())
        }
    }
    
    func getMyAdvertisements(uid: String) async throws -> [Advertisement] {
        let ref = db.collection("advertisements")
        let query = ref.whereField("uid", isEqualTo: uid)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap {
            Advertisement(documentId: $0.documentID, data: $0.data())
        }
    }
    
    func getFavouriteAdvertisements(ids: [String]) async throws -> [Advertisement] {
        let ref = db.collection("advertisements")
        let query = ref.whereField(FieldPath.documentID(), in: ids)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap {
            Advertisement(documentId: $0.documentID, data: $0.data())
        }
    }
    
    func advertisementsByCategory(category: AdvertisementCategory) async throws -> [Advertisement] {
        let ref = db.collection("advertisements")
        let query = ref.whereField("category", isEqualTo: category.rawValue)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap {
            Advertisement(documentId: $0.documentID, data: $0.data())
        }
    }
    
    func createAdvertisement(advertisement: Advertisement) async throws {
        try await db.collection("advertisements").addDocument(data: advertisement.dictionary)
    }
    
    func deleteAdvertisement(advertisement: Advertisement) async throws {
        let ref = db.collection("advertisements")
        
        try await ref.document(advertisement.id).delete()
    }
}
