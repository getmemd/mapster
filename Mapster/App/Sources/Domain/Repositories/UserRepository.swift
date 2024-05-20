//
//  UserRepository.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 09.05.2024.
//

import Factory
import Foundation

enum UserRepositoryError: Error {
    case userNotFound
    case unableToConvertUser
    
    var localizedDescription: String {
        switch self {
        case .userNotFound:
            return "User not found"
        case .unableToConvertUser:
            return "Failed to convert data to user"
        }
    }
}

final class UserRepository {
    @Injected(\.db) private var db
    
    func createUser(user: AppUser) async throws {
        let ref = try await db.collection("users").addDocument(data: user.dictionary)
        print("User successfully added with ID: \(ref.documentID)")
    }
    
    func getUser(uid: String) async throws -> AppUser {
        let usersRef = db.collection("users")
        let query = usersRef.whereField("uid", isEqualTo: uid)
        let snapshot = try await query.getDocuments()
        guard let data = snapshot.documents.first?.data(), let user = AppUser(data: data) else {
            throw UserRepositoryError.unableToConvertUser
        }
        return user
    }
    
    func editUser(uid: String, phoneNumber: String) async throws {
        let usersRef = db.collection("users")
        let query = usersRef.whereField("uid", isEqualTo: uid)
        let snapshot = try await query.getDocuments()
        guard let document = snapshot.documents.first else {
            throw UserRepositoryError.userNotFound
        }
        try await document.reference.updateData(["phoneNumber": phoneNumber])
    }
}
