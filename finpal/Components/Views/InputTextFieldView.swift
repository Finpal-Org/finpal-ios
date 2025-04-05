//
//  InputTextFieldView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/29/25.
//

import SwiftUI

struct InputTextFieldView: View {
    let placeholder: String
    let iconName: String
    let maxCount: Int?
    let showError: Binding<Bool>?
    let text: Binding<String>
    
    private let textFieldHeight: CGFloat = 48
    
    init(_ placeholder: String, iconName: String, maxCount: Int? = nil, showError: Binding<Bool>? = nil, text: Binding<String>) {
        self.placeholder = placeholder
        self.iconName = iconName
        self.maxCount = maxCount
        self.showError = showError
        self.text = text
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.gray60)
                    .frame(width: 20, height: 20)
                    .padding(.leading, 12)
                
                TextField("", text: text)
                    .keyboardType(.emailAddress)
                    .placeholder(when: text.wrappedValue.isEmpty) {
                        Text(placeholder)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(Color.gray60)
                    }
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity)
                    .frame(height: textFieldHeight)
                    .foregroundStyle(Color.gray80)
                    .padding(.leading, 8)
                    .padding(.trailing, 12)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onReceive(text.wrappedValue.publisher.collect()) { output in
                        if let maxCount {
                            let s = String(output.prefix(maxCount))
                            
                            if text.wrappedValue != s && (maxCount != 0) {
                                text.wrappedValue = s
                            }
                        }
                    }
                    .truncationMode(.middle)
                    .background(Color.clear)
            }
            .background {
                Capsule()
                    .stroke(getStrokeColor(), lineWidth: 1)
                    .background(Color.white, in: .capsule)
            }
        }
    }
    
    private func getStrokeColor() -> Color {
        if showError?.wrappedValue ?? false {
            return Color.destructive60
        }
        
        return Color.gray30
    }
}

private struct PreviewView: View {
    @State private var email: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        ZStack {
            Color.gray5.ignoresSafeArea()
            
            InputTextFieldView("Enter your email address...", iconName: "envelope", showError: $showError, text: $email)
        }
    }
}

#Preview {
    PreviewView()
}
