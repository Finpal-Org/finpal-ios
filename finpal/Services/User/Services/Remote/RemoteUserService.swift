//
//  RemoteUserService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/6/25.
//

import Foundation

protocol RemoteUserService: Sendable {
    func saveUser(user: UserModel) async throws
    func markOnboardingCompleted(userId: String) async throws
    func markChatbotScreenVisited(userId: String) async throws
    func streamUser(userId: String, onListenerConfigured: @escaping (ListenerRegistration) -> Void) -> AsyncThrowingStream<UserModel, Error>
    func deleteUser(userId: String) async throws
}
