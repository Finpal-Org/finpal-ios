//
//  AuthService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/5/25.
//

import SwiftUI
import FirebaseAuth

enum AppAuthError: Error {
    case emailRequired
    case passwordRequired
    case invalidEmail
    case invalidPassword
    case invalidPasswordLength
    case invalidCredential
    case passwordsDoNotMatch
    case emailAlreadyInUse
    case userNotFound
    case tooManyRequests
    case networkError
    
    var localizedDescription: String {
        switch self {
        case .emailRequired:
            return "Please enter your email."
        case .passwordRequired:
            return "Please enter a password."
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
        case .networkError:
            return "There was an issue connecting to the server."
        }
    }
}

final class AuthService: Sendable {
    nonisolated(unsafe) var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    private init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
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
    }
    
    func createUser(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
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
    }
    
}
