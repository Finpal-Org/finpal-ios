//
//  RegistrationViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/28/25.
//

import SwiftUI

@Observable
class RegistrationViewModel {
    var email = ""
    var password = ""
    var confirmPassword = ""
    var strength: PasswordStrength = .none
    
    var showEmailError = false
    var showPasswordError = false
    var showConfirmPasswordError = false
    
    var showPopup = false
    var errorMessage = ""
    
    func clearErrors() {
        showEmailError = false
        showPasswordError = false
        showConfirmPasswordError = false
        showPopup = false
    }
    
    func validateForm() throws {
        if email.isEmpty {
            showError(showEmailError: true, showPasswordError: false, showConfirmPasswordError: false)
            throw AppAuthError.emailRequired
        }
        
        if !isValidEmail(email) {
            showError(showEmailError: true, showPasswordError: false, showConfirmPasswordError: false)
            throw AppAuthError.invalidEmail
        }
        
        if password.isEmpty {
            showError(showEmailError: false, showPasswordError: true, showConfirmPasswordError: false)
            throw AppAuthError.passwordRequired
        }
        
        if confirmPassword.isEmpty {
            showError(showEmailError: false, showPasswordError: false, showConfirmPasswordError: true)
            throw AppAuthError.confirmPasswordRequired
        }
        
        if confirmPassword != password {
            showError(showEmailError: false, showPasswordError: true, showConfirmPasswordError: true)
            throw AppAuthError.passwordsDoNotMatch
        }
        
        if strength != .strong && strength != .veryStrong {
            showError(showEmailError: false, showPasswordError: true, showConfirmPasswordError: false)
            throw AppAuthError.invalidPasswordLength
        }
        
        showError(showEmailError: false, showPasswordError: false, showConfirmPasswordError: false)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func showError(showEmailError: Bool, showPasswordError: Bool, showConfirmPasswordError: Bool) {
        self.showEmailError = showEmailError
        self.showPasswordError = showPasswordError
        self.showConfirmPasswordError = showConfirmPasswordError
    }
}
