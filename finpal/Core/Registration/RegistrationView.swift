//
//  RegistrationView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/8/25.
//

import SwiftUI

struct RegistrationView: View {
    @State private var showProfileSetupScreens: Bool = false
    
    @State private var showErrorPopup: Bool = false
    @State private var showEmailError: Bool = false
    @State private var showPasswordError: Bool = false
    @State private var showConfirmPasswordError: Bool = false
    @State private var errorMessage: String = ""
    
    @StateObject private var viewModel = RegistrationViewModel()
    
    @Environment(AuthenticationRouter.self) private var router
    
    var body: some View {
        VStack(spacing: 48) {
            Spacer()
            
            titleView
            
            VStack(spacing: 28) {
                emailView
                passwordView
                confirmPasswordView
            }
            
            buttonsView
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray5)
        .errorPopup(showingPopup: $showErrorPopup, errorMessage)
    }
    
    private var titleView: some View {
        VStack {
            Image(.logoPlain)
                .resizable()
                .scaledToFit()
                .frame(width: 94, height: 94)
            
            Text("Sign Up to finpal")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
        }
    }
    
    private var emailView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email Address")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            InputTextFieldView(
                "Enter your email address...",
                iconName: "envelope",
                showError: $showEmailError,
                text: $viewModel.email
            )
        }
    }
    
    private var passwordView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            InputPasswordView(
                "Enter your password...",
                iconName: "lock",
                showError: $showPasswordError,
                text: $viewModel.password
            )
            
            PasswordStrengthView(viewModel: viewModel)
        }
    }
    
    private var confirmPasswordView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Confirm Password")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            InputPasswordView(
                "Enter your password...",
                iconName: "lock",
                showError: $showConfirmPasswordError,
                text: $viewModel.confirmPassword
            )
        }
    }
    
    private var buttonsView: some View {
        VStack(spacing: 32) {
            Text("Create Account")
                .callToActionButton()
                .anyButton(.press) {
                    withAnimation(.spring) {
                        onCreateAccountPressed()
                    }
                }
            
            Text("I Already Have Account")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.accent)
                .underline()
                .anyButton {
                    router.navigateToLogin()
                }
        }
    }
    
    private func validateFields() {
        let email = viewModel.email
        let password = viewModel.password
        let confirmPassword = viewModel.confirmPassword
        let passwordStrength = viewModel.passwordStrength
        
        if email.isEmpty {
            errorMessage = "Please enter your email."
            showErrorPopup = true
            
            showEmailError = true
            showPasswordError = false
            showConfirmPasswordError = false
            return
        }
        
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email format."
            showErrorPopup = true
            
            showEmailError = true
            showPasswordError = false
            showConfirmPasswordError = false
            return
        }
        
        if password.isEmpty {
            errorMessage = "Please enter a password."
            showErrorPopup = true
            
            showEmailError = false
            showPasswordError = true
            showConfirmPasswordError = false
            return
        }
        
        if confirmPassword.isEmpty {
            errorMessage = "Please confirm your password."
            showErrorPopup = true
            
            showEmailError = false
            showPasswordError = false
            showConfirmPasswordError = true
            return
        }
        
        if confirmPassword != password {
            errorMessage = "Passwords do not match."
            showErrorPopup = true
            
            showEmailError = false
            showPasswordError = true
            showConfirmPasswordError = true
            return
        }
        
        if passwordStrength != .veryStrong {
            errorMessage = "Password is too weak."
            showErrorPopup = true
            
            showEmailError = false
            showPasswordError = true
            showConfirmPasswordError = false
            return
        }
        
        showErrorPopup = false
        showEmailError = false
        showPasswordError = false
        showConfirmPasswordError = false
        
        router.navigateToSetup(email: viewModel.email, password: viewModel.password)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func onCreateAccountPressed() {
        validateFields()
    }
}

#Preview {
    RegistrationView()
        .withRouter()
}
