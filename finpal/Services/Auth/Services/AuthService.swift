//
//  AuthService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/5/25.
//

import SwiftUI
import FirebaseAuth

protocol AuthService: Sendable {
    func addAuthenticatedUserListener(onListenerAttached: (any NSObjectProtocol) -> Void) -> AsyncStream<UserAuthInfo?>
    func getAuthenticatedUser() -> UserAuthInfo?
    func signIn(withEmail email: String, password: String) async throws -> UserAuthInfo
    func createUser(withEmail email: String, password: String, fullName: String, monthlyIncome: Int, savingsPercentage: Int) async throws -> UserAuthInfo
    func signOut() throws
    func deleteAccount() async throws
}
