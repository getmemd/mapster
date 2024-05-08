//
//  AdvertisementRepository.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 01.04.2024.
//

import Factory
import Foundation

final class AdvertisementRepository {
    @Injected(\.db) private var db
    
    func getAdvertisements() async throws -> [Advertisement] {
        let snapshot = try await db.collection("advertisements").getDocuments()
        return snapshot.documents.compactMap {
            Advertisement(data: $0.data())
        }
    }
    
    func addAdvertisement(advertisement: Advertisement) async throws {
        let jsonData = try JSONEncoder().encode(advertisement)
        guard let data = try JSONSerialization.jsonObject(
            with: jsonData,
            options: .allowFragments
        ) as? [String: Any] else {
            throw NSError(
                domain: "AdvertisementError",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Failed to convert advertisement to dictionary"]
            )
        }
        let ref = try await db.collection("advertisements").addDocument(data: data)
        print("Advertisement successfully added with ID: \(ref.documentID)")
    }
    
    func getLikedAdvertisement() async throws {
//        let ref = try await db.collection("advertisements").
    }
}
