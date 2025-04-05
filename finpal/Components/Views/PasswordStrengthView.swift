//
//  PasswordStrengthView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/8/25.
//

import SwiftUI

enum PasswordStrength {
    case none
    case weak
    case moderate
    case strong
    case veryStrong
    
    var level: Int {
        switch self {
        case .none:
            return 0
        case .weak:
            return 1
        case .moderate:
            return 2
        case .strong:
            return 3
        case .veryStrong:
            return 4
        }
    }
    
    var color: Color {
        switch self {
        case .none:
            return Color.gray30
        case .weak:
            return Color.destructive50
        case .moderate:
            return Color.yellow
        case .strong:
            return Color.blue
        case .veryStrong:
            return Color.brand60
        }
    }
    
    func color(for index: Int) -> Color {
        switch self {
        case .none:
            return Color.gray30
        case .weak:
            return index == 0 ? Color.destructive50 : Color.gray30
        case .moderate:
            return index < 2 ? Color.yellow : Color.gray30
        case .strong:
            return index < 3 ? Color.yellow : Color.gray30
        case .veryStrong:
            return index < 4 ? Color.brand60 : Color.gray30
        }
    }
    
    
    var message: String {
        switch self {
        case .none:
            return ""
        case .weak:
            return "Weak! Please add more strength! 💪"
        case .moderate, .strong:
            return "Medium strength. Keep going! 🚀"
        case .veryStrong:
            return "Password strength: Great! 👍"
        }
    }
}

struct PasswordStrengthView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    
    private var passwordStrength: PasswordStrength {
        let password = viewModel.password
        
        if password.isEmpty {
            return .none
        }
        
        let criteria = [
            viewModel.hasTenChar,
            viewModel.hasSpacialChar,
            viewModel.hasOneDigit,
            viewModel.hasOneUpperCaseChar
        ]
        
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                ForEach(0...3, id: \.self) { index in
                    Capsule()
                        .frame(maxWidth: .infinity)
                        .frame(height: 4)
                        .foregroundStyle(passwordStrength.color(for: index))
                }
            }
            
            Text(passwordStrength.message)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.gray60)
        }
        .animation(.bouncy, value: passwordStrength)
    }
}

private struct PreviewView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    
    var body: some View {
        VStack {
            TextField("Password", text: $viewModel.password)
            
            PasswordStrengthView(viewModel: viewModel)
        }
    }
}

#Preview {
    PreviewView()
}
