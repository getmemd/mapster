//
//  AdvertisementRepository.swift
//  Mapster
//
//  Created by User on 01.04.2024.
//

import Factory

final class AdvertisementRepository {
    @Injected(\.db) private var db
    
    func getAdvertisements() async throws -> [Advertisement] {
        let snapshot = try await db.collection("advertisements").getDocuments()
        return snapshot.documents.compactMap {
            Advertisement(data: $0.data())
        }
    }
    
    func addAdvertisement(data: [String: Any]) async throws {
        let ref = try await db.collection("advertisements").addDocument(data: data)
        print("success added with ID: \(ref.documentID)")
    }
    
    func getLikedAdvertisement() async throws {
//        let ref = try await db.collection("advertisements").
    }
}
