//
//  FirebaseAuthService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/7/25.
//

import SwiftUI
import FirebaseAuth

struct FirebaseAuthService: AuthService {
    
    func addAuthenticatedUserListener(onListenerAttached: (any NSObjectProtocol) -> Void) -> AsyncStream<UserAuthInfo?> {
        AsyncStream { continuation in
            let listener = Auth.auth().addStateDidChangeListener { _, currentUser in
                if let currentUser {
                    let user = UserAuthInfo(user: currentUser)
                    continuation.yield(user)
                } else {
                    continuation.yield(nil)
                }
            }
            
            onListenerAttached(listener)
        }
    }
    
    func getAuthenticatedUser() -> UserAuthInfo? {
        if let user = Auth.auth().currentUser {
            return UserAuthInfo(user: user)
        }
        return nil
    }
    
    func signIn(withEmail email: String, password: String) async throws -> UserAuthInfo {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return UserAuthInfo(user: result.user)
    }
    
    func createUser(withEmail email: String, password: String) async throws -> UserAuthInfo {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return UserAuthInfo(user: result.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AppAuthError.userNotFound
        }
        
        try await user.delete()
    }
}
