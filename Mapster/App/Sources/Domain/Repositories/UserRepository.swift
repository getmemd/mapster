import Factory
import Firebase
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
        try await db.collection("users").addDocument(data: user.dictionary)
    }
    
    func getUser(uid: String) async throws -> AppUser {
        let document = try await getUserDocument(uid: uid)
        guard let user = AppUser(data: document.data()) else {
            throw UserRepositoryError.unableToConvertUser
        }
        return user
    }
    
    func editUser(uid: String, phoneNumber: String) async throws {
        let document = try await getUserDocument(uid: uid)
        try await document.reference.updateData(["phoneNumber": phoneNumber])
    }
    
    func editFavourites(uid: String, favouriteAdvertisementsIds: [String]) async throws {
        let document = try await getUserDocument(uid: uid)
        try await document.reference.updateData(["favouriteAdvertisementsIds": favouriteAdvertisementsIds])
    }
    
    private func getUserDocument(uid: String) async throws -> QueryDocumentSnapshot {
        let usersRef = db.collection("users")
        let query = usersRef.whereField("uid", isEqualTo: uid)
        let snapshot = try await query.getDocuments()
        guard let document = snapshot.documents.first else {
            throw UserRepositoryError.userNotFound
        }
        return document
    }
}
