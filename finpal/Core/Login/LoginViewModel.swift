//
//  LoginViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/19/25.
//

import SwiftUI
import Observation

@Observable class LoginViewModel {
    var email = ""
    var showEmailError = false
    
    var password = ""
    var showPasswordError = false
    
    var showPopup = false
    var errorMessage = ""
    
    func clearErrors() {
        showEmailError = false
        showPasswordError = false
    }
    
    func validateForm() throws {
        if email.isEmpty {
            showEmailError = true
            throw AppAuthError.emailRequired
        }
        
        if !isValidEmail(email) {
            showEmailError = true
            throw AppAuthError.invalidEmail
        }
        
        if password.isEmpty {
            showPasswordError = true
            throw AppAuthError.passwordRequired
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
