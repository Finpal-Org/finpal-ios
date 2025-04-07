//
//  MockAuthService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/7/25.
//

import Foundation

struct MockAuthService: AuthService {
    let currentUser: UserAuthInfo?
    
    init(user: UserAuthInfo? = nil) {
        self.currentUser = user
    }
    
    func addAuthenticatedUserListener(onListenerAttached: (any NSObjectProtocol) -> Void) -> AsyncStream<UserAuthInfo?> {
        AsyncStream { continuation in
            continuation.yield(currentUser)
        }
    }
    
    func getAuthenticatedUser() -> UserAuthInfo? {
        currentUser
    }
    
    func signIn(withEmail email: String, password: String) async throws -> UserAuthInfo {
        .mock
    }
    
    func createUser(withEmail email: String, password: String, fullName: String, monthlyIncome: Int, savingsPercentage: Int) async throws -> UserAuthInfo {
        .mock
    }
    
    func signOut() throws {
        
    }
    
    func deleteAccount() async throws {
        
    }
}
