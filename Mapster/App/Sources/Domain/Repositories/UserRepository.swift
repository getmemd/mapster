import Factory
import Foundation

final class UserRepository {
    @Injected(\.db) private var db
    
    func createUser(user: AppUser) async throws {
        let ref = try await db.collection("users").addDocument(data: user.dictionary)
        print("User successfully added with ID: \(ref.documentID)")
    }
    
    func getUser(uid: String) async throws -> AppUser {
        let usersRef = db.collection("users")
        usersRef.whereField("uid", isEqualTo: uid)
        let snapshot = try await usersRef.getDocuments()
        guard let data = snapshot.documents.first?.data(), let user = AppUser(data: data) else {
            throw NSError(
                domain: "UserError",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to user"]
            )
        }
        return user
    }
}
