import Factory
import Firebase
import Foundation

// Перечисление ошибок для UserRepository
enum UserRepositoryError: Error {
    case userNotFound
    case unableToConvertUser
    
    // Локализованное описание ошибок
    var localizedDescription: String {
        switch self {
        case .userNotFound:
            return "User not found"
        case .unableToConvertUser:
            return "Failed to convert data to user"
        }
    }
}

// Финальный класс для работы с пользователями
final class UserRepository {
    // Внедрение зависимости базы данных
    @Injected(\.db) private var db
    
    // Создание пользователя
    func createUser(user: AppUser) async throws {
        try await db.collection("users").addDocument(data: user.dictionary)
    }
    
    // Получение пользователя по UID
    func getUser(uid: String) async throws -> AppUser {
        let document = try await getUserDocument(uid: uid)
        guard let user = AppUser(data: document.data()) else {
            throw UserRepositoryError.unableToConvertUser
        }
        return user
    }
    
    // Редактирование номера телефона пользователя
    func editUser(uid: String, phoneNumber: String) async throws {
        let document = try await getUserDocument(uid: uid)
        try await document.reference.updateData(["phoneNumber": phoneNumber])
    }
    
    // Редактирование избранных объявлений пользователя
    func editFavourites(uid: String, favouriteAdvertisementsIds: [String]) async throws {
        let document = try await getUserDocument(uid: uid)
        try await document.reference.updateData(["favouriteAdvertisementsIds": favouriteAdvertisementsIds])
    }
    
    // Получение документа пользователя по UID
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
