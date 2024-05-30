import FirebaseAuth

final class AuthRepository {
    func authorization(email: String, password: String, isRegistration: Bool) async throws {
        if isRegistration {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } else {
            try await Auth.auth().signIn(withEmail: email, password: password)
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func sendEmailVerification() async throws {
        try await Auth.auth().currentUser?.sendEmailVerification()
    }
    
    func updatePassword(password: String) async throws {
        try await Auth.auth().currentUser?.updatePassword(to: password)
    }
    
    func sendPasswordResetEmail(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updateUser(name: String) async throws {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        try await changeRequest?.commitChanges()
    }
}
