//
//  AuthRepository.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 07.03.2024.
//

import FirebaseAuth

final class AuthRepository {
    func authorization(email: String, password: String, isRegistration: Bool) async throws -> AuthDataResult {
        if isRegistration {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } else {
            try await Auth.auth().signIn(withEmail: email, password: password)
        }
    }
    
    func signOut() throws {
        let firebaseAuth = Auth.auth()
        try firebaseAuth.signOut()
    }
    
    func sendEmailVerification(completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification { error in
            completion(error)
        }
    }
    
    func updatePassword(password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            completion(error)
        }
    }
    
    func sendPasswordResetEmail(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}
