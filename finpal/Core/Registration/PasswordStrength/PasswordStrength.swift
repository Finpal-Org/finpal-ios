//
//  PasswordStrength.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/6/25.
//

import SwiftUI

enum PasswordStrength: String {
    case none = ""
    case weak = "Weak! Please add more strength! 💪"
    case moderate = "Medium strength. Keep going! 🚀"
    case strong = "Password strength: Great! 👍"
    case veryStrong = "Amazing! Your password is super strong! 🔥"
    
    var color: Color {
        switch self {
        case .none:
            return Color.gray30
        case .weak:
            return Color.destructive50
        case .moderate:
            return Color.yellow
        case .strong:
            return Color.brand60
        case .veryStrong:
            return Color.brand60
        }
    }
}
