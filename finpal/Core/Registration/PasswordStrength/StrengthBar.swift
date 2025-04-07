//
//  StrengthBar.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/6/25.
//

import SwiftUI

struct StrengthBar: View {
    var strength: PasswordStrength
    
    private let emptyColor: Color = Color.gray30
    
    var body: some View {
        GeometryReader { geometry in
            switch strength {
            case .none:
                HStack {
                    ForEach(0..<4) { _ in
                        StrenghtBarSegment(color: strength.color, maxWidth: geometry.size.width / 4)
                    }
                }
                .frame(maxHeight: 8)
            case .weak:
                HStack {
                    StrenghtBarSegment(color: strength.color, maxWidth: geometry.size.width / 4)
                    
                    ForEach(0..<3) { _ in
                        StrenghtBarSegment(color: emptyColor, maxWidth: geometry.size.width / 4)
                    }
                }
                .frame(maxHeight: 8)
            case .moderate:
                HStack {
                    ForEach(0..<2) { _ in
                        StrenghtBarSegment(color: strength.color, maxWidth: geometry.size.width / 4)
                    }
                    
                    ForEach(0..<2) { _ in
                        StrenghtBarSegment(color: emptyColor, maxWidth: geometry.size.width / 4)
                    }
                }
                .frame(maxHeight: 8)
            case .strong:
                HStack {
                    ForEach(0..<3) { _ in
                        StrenghtBarSegment(color: strength.color, maxWidth: geometry.size.width / 4)
                    }
                    
                    StrenghtBarSegment(color: emptyColor, maxWidth: geometry.size.width / 4)
                }
                .frame(maxHeight: 8)
            case .veryStrong:
                HStack {
                    ForEach(0..<4) { _ in
                        StrenghtBarSegment(color: strength.color, maxWidth: geometry.size.width / 3)
                    }
                }
                .frame(maxHeight: 8)
            }
        }
        .frame(maxHeight: 8)
    }
}

struct StrenghtBarSegment: View {
    var color: Color
    var maxWidth: CGFloat
    
    var body: some View {
        Capsule()
            .fill(color)
            .frame(height: 4)
            .frame(maxWidth: maxWidth)
    }
}

#Preview {
    StrengthBar(strength: .weak)
}
