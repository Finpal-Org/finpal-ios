//
//  RemoteUserService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/6/25.
//

import SwiftUI

protocol RemoteUserService: Sendable {
    func saveUser(auth: UserAuthInfo, fullName: String, monthlyIncome: Int, savingsPercentage: Int, image: UIImage?) async throws
    func markOnboardingCompleted(userId: String) async throws
    func markChatbotScreenVisited(userId: String) async throws
    func streamUser(userId: String, onListenerConfigured: @escaping (ListenerRegistration) -> Void) -> AsyncThrowingStream<UserModel, Error>
    func deleteUser(userId: String) async throws
    func fetchCurrentUser(auth: UserAuthInfo) async throws -> UserModel
}
