//
//  RegistrationViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/28/25.
//

import Combine
import Foundation

final class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var passwordStrength: PasswordStrength = .none
    
    @Published var hasTenChar = false
    @Published var hasSpacialChar = false
    @Published var hasOneDigit = false
    @Published var hasOneUpperCaseChar = false
    @Published var confirmationMatch = false
    @Published var areAllFieldsValid = false
    
    init() {
        validateSignUpFields()
        calculatePasswordStrength()
    }
    
    private func validateSignUpFields() {
        $password
            .map { password in
                password.count >= 10
            }
            .assign(to: &$hasTenChar)
        
        // Check password has minimum 1 special character
        $password
            .map { password in
                password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|:\"';<>,.?/~`")) != nil
            }
            .assign(to: &$hasSpacialChar)
        
        // Check password has minimum 1 digit
        $password
            .map { password in
                password.contains { $0.isNumber }
            }
            .assign(to: &$hasOneDigit)
        
        // Check password has minimum 1 uppercase letter
        $password
            .map { password in
                password.contains { $0.isUppercase }
            }
            .assign(to: &$hasOneUpperCaseChar)
        
        // Check confirmation match password
        Publishers.CombineLatest($password, $confirmPassword)
            .map { [weak self] _, _ in
                guard let self else { return false}
                return self.password == self.confirmPassword
            }
            .assign(to: &$confirmationMatch)
        
        // Check all fields match
        Publishers.CombineLatest($password, $confirmPassword)
            .map { [weak self] _, _ in
                guard let self else { return false}
                return self.hasTenChar && self.hasSpacialChar && self.hasOneDigit && self.hasOneUpperCaseChar && self.confirmationMatch
            }
            .assign(to: &$areAllFieldsValid)
    }
    
    func calculatePasswordStrength() {
        Publishers.CombineLatest4($hasTenChar, $hasSpacialChar, $hasOneDigit, $hasOneUpperCaseChar)
            .map { hasTenChar, hasSpecialChar, hasDigit, hasUpperCase in
                if self.password.isEmpty {
                    return PasswordStrength.none
                }
                
                let criteria = [hasTenChar, hasSpecialChar, hasDigit, hasUpperCase]
                let metCriteriaCount = criteria.filter { $0 }.count
                
                switch metCriteriaCount {
                case 0:
                    return .none
                case 1:
                    return .weak
                case 2:
                    return .moderate
                case 3:
                    return .strong
                case 4:
                    return .veryStrong
                default:
                    return .none
                }
            }
            .assign(to: &$passwordStrength)
    }
}
