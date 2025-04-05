//
//  LoginView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/7/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthenticationRouter.self) private var router
    
    @State private var viewModel = SignInViewModel()
    
    @State private var rememberMe: Bool = true
    
    @State private var isForgotPasswordPresented: Bool = false
    
    var body: some View {
        VStack {
            VStack(spacing: 40) {
                // Logo and Title
                VStack(spacing: 24) {
                    Image(.logoPlain)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 94, height: 94)
                    
                    Text("Sign In to finpal")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Color.gray80)
                }
                
                // Fields
                VStack(spacing: 24) {
                    emailAddressField
                    passwordField
                    rememberMeButton
                }
                
                // Buttons
                VStack(spacing: 12) {
                    signInButton
                    createNewAccountButton
                }
                
                forgotPasswordButton
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray5)
        .fullScreenCover(isPresented: $isForgotPasswordPresented) {
            ForgotPasswordView()
        }
        .errorPopup(showingPopup: $viewModel.errorAlert.isPresented, viewModel.errorAlert.message)
    }
    
    private var emailAddressField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email Address")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            InputTextFieldView(
                "Enter your email address...",
                iconName: "envelope",
                showError: $viewModel.errorAlert.isPresented,
                text: $viewModel.email
            )
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            InputPasswordView(
                "Enter your password...",
                iconName: "lock",
                showError: $viewModel.errorAlert.isPresented,
                text: $viewModel.password
            )
        }
    }
    
    private var rememberMeButton: some View {
        HStack(spacing: 8) {
            Image(systemName: rememberMe ? "checkmark.circle.fill" : "circle")
                .frame(width: 20, height: 20)
                .foregroundStyle(.accent)
                .onTapGesture {
                    rememberMe.toggle()
                }
            
            Text("Remember for 30 days")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.gray80)
            
            Spacer()
        }
    }
    
    private var signInButton: some View {
        Text("Sign In")
            .callToActionButton()
            .anyButton(.press) {
                onSignInButtonPressed()
            }
    }
    
    private var createNewAccountButton: some View {
        Text("Create New Account")
            .secondaryButton()
            .anyButton(.press) {
                onCreateAccountButtonPressed()
            }
    }
    
    private var forgotPasswordButton: some View {
        Button {
            onForgotPasswordPressed()
        } label: {
            Text("Forgot Password")
                .font(.callout)
                .fontWeight(.semibold)
                .underline()
        }
    }
    
    private func onSignInButtonPressed() {
        viewModel.signIn()
    }
    
    private func onCreateAccountButtonPressed() {
        router.navigateToSignUp()
    }
    
    private func onForgotPasswordPressed() {
        isForgotPasswordPresented = true
    }
}

#Preview {
    LoginView()
        .withRouter()
}
