//
//  UserManager.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import SwiftUI

@MainActor
@Observable class UserManager {
    private let remote: RemoteUserService
    private let local: LocalUserPersistence
    
    private(set) var currentUser: UserModel?
    private var currentUserListener: ListenerRegistration?
    
    init(services: UserServices) {
        self.remote = services.remote
        self.local = services.local
        self.currentUser = local.getCurrentUser()
    }
    
    func fetchUser(auth: UserAuthInfo) async throws {
        let user = try await remote.fetchCurrentUser(auth: auth)
        self.currentUser = user
        print("Successfully listened to user: \(user.userId)")
    }
    
    func saveUser(auth: UserAuthInfo, fullName: String, monthlyIncome: Int, savingsPercentage: Int, image: UIImage?) async throws {
        try await remote.saveUser(auth: auth, fullName: fullName, monthlyIncome: monthlyIncome, savingsPercentage: savingsPercentage, image: image)
        try await fetchUser(auth: auth)
//        addCurrentUserListener(userId: auth.uid)
    }
    
//    func addCurrentUserListener(userId: String) {
//        currentUserListener?.remove()
//        
//        Task {
//            do {
//                for try await value in remote.streamUser(userId: userId, onListenerConfigured: { listener in
//                    self.currentUserListener = listener
//                }) {
//                    self.currentUser = value
//                    self.saveCurrentUserLocally()
//                    print("Successfully listened to user: \(value.userId)")
//                }
//            } catch {
//                print("Error attaching user listener: \(error)")
//            }
//        }
//    }
    
    private func saveCurrentUserLocally() {
        Task {
            do {
                try local.saveCurrentUser(user: currentUser)
                print("Successfully saved current user locally")
            } catch {
                print("Error saving current user locally: \(error)")
            }
        }
    }
    
    func markOnboardingCompleteForCurrentUser() async throws {
        let uid = try currentUserId()
        try await remote.markOnboardingCompleted(userId: uid)
    }
    
    func markChatbotScreenVisitedForCurrentUser() async throws {
        let uid = try currentUserId()
        try await remote.markChatbotScreenVisited(userId: uid)
    }
    
    func signOut() {
        currentUserListener?.remove()
        currentUserListener = nil
        currentUser = nil
    }
    
    func deleteCurrentUser() async throws {
        let uid = try currentUserId()
        try await remote.deleteUser(userId: uid)
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
