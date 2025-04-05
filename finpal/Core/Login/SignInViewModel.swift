//
//  SignInViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/6/25.
//

import SwiftUI

@MainActor
@Observable final class SignInViewModel {
    var email = ""
    var password = ""
    var errorAlert: (isPresented: Bool, message: String) = (false, "")
    
    private func validateFields() throws {
        if email.isEmpty {
            throw AppAuthError.emailRequired
        }
        
        if !isValidEmail(email) {
            throw AppAuthError.invalidEmail
        }
        
        if password.isEmpty {
            throw AppAuthError.passwordRequired
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func signIn() {
        Task {
            do {
                try validateFields()
                try await AuthService.shared.signIn(withEmail: email, password: password)
            } catch let error as AppAuthError {
                errorAlert.isPresented = true
                errorAlert.message = error.localizedDescription
            } catch {
                errorAlert.isPresented = true
                errorAlert.message = error.localizedDescription
            }
        }
    }
}
