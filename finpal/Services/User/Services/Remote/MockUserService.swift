//
//  MockUserService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import SwiftUI

struct MockUserService: RemoteUserService {
    let currentUser: UserModel?
    
    init(user: UserModel? = nil) {
        self.currentUser = user
    }
    
    func saveUser(auth: UserAuthInfo, fullName: String, monthlyIncome: Int, savingsPercentage: Int, image: UIImage?) async throws {
        
    }
    
    func markOnboardingCompleted(userId: String) async throws {
        
    }
    
    func markChatbotScreenVisited(userId: String) async throws {
        
    }
    
    func streamUser(userId: String, onListenerConfigured: @escaping (any ListenerRegistration) -> Void) -> AsyncThrowingStream<UserModel, any Error> {
        AsyncThrowingStream { continuation in
            if let currentUser {
                continuation.yield(currentUser)
            }
        }
    }
    
    func deleteUser(userId: String) async throws {
        
    }
    
    func fetchCurrentUser(auth: UserAuthInfo) async throws -> UserModel {
        .mock
    }
}
