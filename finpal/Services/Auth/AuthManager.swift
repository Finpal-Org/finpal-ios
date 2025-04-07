//
//  AuthManager.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/7/25.
//

import SwiftUI

@MainActor
@Observable class AuthManager {
    
    private let service: AuthService
    
    private(set) var auth: UserAuthInfo?
    private var listener: (any NSObjectProtocol)?
    
    init(service: AuthService) {
        self.service = service
        self.auth = service.getAuthenticatedUser()
        self.addAuthListener()
    }
    
    private func addAuthListener() {
        Task {
            for await value in service.addAuthenticatedUserListener(onListenerAttached: { listener in
                self.listener = listener
            }) {
                self.auth = value
                print("Auth listener success: \(value?.uid ?? "no uid")")
            }
        }
    }
    
    func getAuthId() throws -> String {
        guard let uid = auth?.uid else {
            throw AppAuthError.notSignedIn
        }
        
        return uid
    }
    
    func signIn(withEmail email: String, password: String) async throws -> UserAuthInfo {
        try await service.signIn(withEmail: email, password: password)
    }
    
    func createUser(withEmail email: String, password: String, fullName: String, monthlyIncome: Int, savingsPercentage: Int) async throws -> UserAuthInfo {
        try await service.createUser(withEmail: email, password: password, fullName: fullName, monthlyIncome: monthlyIncome, savingsPercentage: savingsPercentage)
    }
    
    func signOut() throws {
        try service.signOut()
        auth = nil
    }
    
    func deleteAccount() async throws {
        try await service.deleteAccount()
        auth = nil
    }
}

enum AppAuthError: Error {
    case emailRequired
    case passwordRequired
    case confirmPasswordRequired
    case invalidEmail
    case invalidPassword
    case invalidPasswordLength
    case invalidCredential
    case passwordsDoNotMatch
    case emailAlreadyInUse
    case userNotFound
    case tooManyRequests
    case notSignedIn
    case networkError
    
    var localizedDescription: String {
        switch self {
        case .emailRequired:
            return "Please enter your email."
        case .passwordRequired:
            return "Please enter a password."
        case .confirmPasswordRequired:
            return "Please confirm your password."
        case .invalidEmail:
            return "Please enter a valid email format."
        case .invalidPassword:
            return "Incorrect password. Please try again."
        case .invalidPasswordLength:
            return "Password is too weak."
        case .invalidCredential:
            return "Invalid credential. Please try again."
        case .passwordsDoNotMatch:
            return "Passwords do not match."
        case .emailAlreadyInUse:
            return "This email is already in use."
        case .userNotFound:
            return "Account not found. Please check your email or sign up."
        case .tooManyRequests:
            return "Too many requests. Please try again later."
        case .notSignedIn:
            return "Please sign in to continue."
        case .networkError:
            return "There was an issue connecting to the server."
        }
    }
}

/*
 } catch let error as NSError {
     let authError = AuthErrorCode(rawValue: error.code)
     switch authError {
     case .invalidCredential:
         throw AppAuthError.invalidCredential
     case .emailAlreadyInUse:
         throw AppAuthError.emailAlreadyInUse
     case .invalidEmail:
         throw AppAuthError.invalidEmail
     case .wrongPassword:
         throw AppAuthError.invalidPassword
     case .tooManyRequests:
         throw AppAuthError.tooManyRequests
     case .userNotFound:
         throw AppAuthError.userNotFound
     case .networkError:
         throw AppAuthError.networkError
     case .weakPassword:
         throw AppAuthError.invalidPasswordLength
     default:
         throw AppAuthError.networkError
     }
 }
 */
