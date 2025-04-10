//
//  ChangePasswordView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/9/25.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var newPassword = ""
    @State private var secureText = true
    
    @State private var checkMinCharacters = false
    @State private var checkUpperAndLower = false
    @State private var checkNumber = false
    @State private var checkSpecialCharacter = false
    @State private var checkNotCommon = false
    
    @State private var showPopup = false
    @State private var errorMessage = ""
    
    private let commonPasswords = ["password", "12345678", "qwertyui", "letmein", "welcome"]
    
    var body: some View {
        VStack(spacing: 32) {
            navigationBar
            
            Image(.changePassword)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 140)
            
            titleView
            secureFieldView
            passwordRequirements
            changePasswordButton
            
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
        .errorPopup(showingPopup: $showPopup, errorMessage)
    }
    
    var isValid: Bool {
        return checkMinCharacters
        && checkUpperAndLower
        && checkNumber
        && checkSpecialCharacter
        && checkNotCommon
    }
    
    private var navigationBar: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray80)
                .anyButton {
                    
                }
            
            Spacer()
        }
        .padding(.vertical)
    }
    
    private var titleView: some View {
        VStack(spacing: 12) {
            Text("Change Password")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Text("Enter your new password")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(Color.gray60)
        }
    }
    
    private var secureFieldView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "lock")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.gray40)
                    .frame(width: 32, height: 32)
                    .padding(.leading, 16)
                
                secureAnyView()
                    .placeholder(when: newPassword.isEmpty) {
                        Text("New password...")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(Color.gray60)
                    }
                    .font(.system(size: 24, weight: .regular))
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .foregroundStyle(Color.gray60)
                    .padding(.horizontal, 10)
                    .autocorrectionDisabled()
                    .onChange(of: newPassword, { oldValue, newValue in
                        validatePassword(newValue)
                    })
                    .truncationMode(.middle)
                    .background(Color.clear)
                
                Image(systemName: secureText ? "eye.slash" : "eye")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.gray40)
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 16)
                    .onTapGesture {
                        secureText.toggle()
                    }
            }
            .background {
                Capsule()
                    .stroke(getBorderColor(), lineWidth: 1)
                    .background(Color.white)
            }
        }
    }
    
    private func secureAnyView() -> AnyView {
        if !secureText {
            return AnyView(
                TextField("", text: $newPassword)
            )
        } else {
            return AnyView(
                SecureField("", text: $newPassword)
            )
        }
    }
    
    private func getBorderColor() -> Color {
        if showPopup {
            return Color.destructive60
        } else {
            return Color.gray30
        }
    }
    
    private var passwordRequirements: some View {
        VStack(alignment: .leading, spacing: 8) {
            ValidationRow(text: "Must be a minimum of 8 characters", check: $checkMinCharacters)
            ValidationRow(text: "One uppercase and lowercase letter", check: $checkUpperAndLower)
            ValidationRow(text: "One number", check: $checkNumber)
            ValidationRow(text: "Must contain special character", check: $checkSpecialCharacter)
            ValidationRow(text: "Must not be common", check: $checkNotCommon)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var changePasswordButton: some View {
        HStack {
            Text("Change Password")
            
            Image(systemName: "lock")
        }
        .callToActionButton()
        .anyButton(.press) {
            onChangePasswordPressed()
        }
    }
    
    private func validatePassword(_ password: String) {
        let isEmpty = password.isEmpty
        
        checkMinCharacters = password.count >= 8
        
        let hasUpper = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLower = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        checkUpperAndLower = hasUpper && hasLower
        
        checkNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        let specialChars = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,./<>?")
        checkSpecialCharacter = password.rangeOfCharacter(from: specialChars) != nil
        
        checkNotCommon = isEmpty ? false : !commonPasswords.contains(password.lowercased())
    }
    
    private func onBackButtonPressed() {
        
    }
    
    private func onChangePasswordPressed() {
        if !isValid {
            errorMessage = ""
            showPopup = true
            return
        }
        
        
    }
}

private struct ValidationRow: View {
    let text: String
    
    @Binding var check: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: check ? "checkmark.circle.fill" : "circle")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.brand60)
            
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.gray80)
        }
    }
}

#Preview {
    ChangePasswordView()
}
