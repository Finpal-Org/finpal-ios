//
//  RegistrationView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/8/25.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(AuthenticationRouter.self) private var router
    
    @State private var viewModel = RegistrationViewModel()
    
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
        .errorPopup(showingPopup: $viewModel.showPopup, viewModel.errorMessage)
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
                keyboardType: .emailAddress,
                error: $viewModel.showEmailError,
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
                showError: $viewModel.showPasswordError,
                text: $viewModel.password
            )
            
            PasswordStrengthView(password: $viewModel.password, strength: $viewModel.strength)
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
                showError: $viewModel.showConfirmPasswordError,
                text: $viewModel.confirmPassword
            )
        }
    }
    
    private var buttonsView: some View {
        VStack(spacing: 32) {
            Text("Create Account")
                .callToActionButton()
                .anyButton(.press) {
                    onCreateAccountButtonPressed()
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
    
    private func onCreateAccountButtonPressed() {
        do {
            try viewModel.validateForm()
            
            router.navigateToSetup(email: viewModel.email, password: viewModel.password)
        } catch let error as AppAuthError {
            viewModel.showPopup = true
            viewModel.errorMessage = error.localizedDescription
        } catch {
            viewModel.showPopup = true
            viewModel.errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    RegistrationView()
        .withRouter()
}
