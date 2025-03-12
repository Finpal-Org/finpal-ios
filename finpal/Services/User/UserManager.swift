//
//  UserManager.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import SwiftUI

@MainActor
@Observable class UserManager {
    private let service: UserService
    
    private(set) var currentUser: UserModel?
    
    init(service: UserService) {
        self.service = service
    }
    
    func markOnboardingCompleteForCurrentUser() async throws {
        let uid = try currentUserId()
        try await service.markOnboardingCompleted(userId: uid)
    }
    
    func signOut() {
        currentUser = nil
    }
    
    func deleteCurrentUser() async throws {
        let uid = try currentUserId()
        try await service.deleteUser(userId: uid)
        signOut()
    }
    
    private func currentUserId() throws -> String {
        guard let uid = currentUser?.userId else {
            throw UserManagerError.noUserId
        }
        
        return uid
    }
    
    enum UserManagerError: LocalizedError {
        case noUserId
    }
}
