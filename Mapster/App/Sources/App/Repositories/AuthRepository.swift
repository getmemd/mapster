//
//  AuthRepository.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 07.03.2024.
//

import FirebaseAuth

final class AuthRepository {
    func authorization(email: String, password: String, isRegistration: Bool) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { continuation in
            let completion: ((AuthDataResult?, (any Error)?) -> Void)? = { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let authResult = authResult {
                    continuation.resume(returning: authResult)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "AuthError",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "Unknown authentication error"])
                    )
                }
            }
            if isRegistration {
                Auth.auth().createUser(withEmail: email, password: password, completion: completion)
            } else {
                Auth.auth().signIn(withEmail: email, password: password, completion: completion)
            }
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
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
