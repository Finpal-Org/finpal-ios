//
//  PasswordStrengthView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/8/25.
//

import SwiftUI

struct PasswordStrengthView: View {
    @Binding var password: String
    @Binding var strength: PasswordStrength
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            StrengthBar(strength: strength)
            
            Text(strength.rawValue)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.gray60)
        }
        .animation(.easeInOut, value: strength)
        .onAppear {
            strength = evaluatePasswordStrength(password)
        }
        .onChange(of: password) { _, newValue in
            strength = evaluatePasswordStrength(newValue)
        }
    }
    
    func evaluatePasswordStrength(_ password: String) -> PasswordStrength {
        if password.isEmpty {
            return .none
        }
        
        let lengthCriteria = password.count >= 8
        let numberCriteria = password.rangeOfCharacter(from: .decimalDigits) != nil
        let uppercaseCriteria = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let specialCharacterCriteria = password.rangeOfCharacter(from: CharacterSet.punctuationCharacters) != nil
        
        let score = [lengthCriteria, numberCriteria, uppercaseCriteria, specialCharacterCriteria].filter { $0 }.count
        
        switch score {
        case 0...1:
            return .weak
        case 2:
            return .moderate
        case 3:
            return .strong
        default:
            return .veryStrong
        }
    }
}

private struct PreviewView: View {
    @State private var password = ""
    @State private var strength: PasswordStrength = .none
    
    var body: some View {
        VStack {
            TextField("Enter your password...", text: $password)
            
            PasswordStrengthView(password: $password, strength: $strength)
        }
    }
}

#Preview {
    PreviewView()
}
