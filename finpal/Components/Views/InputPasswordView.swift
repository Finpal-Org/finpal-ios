//
//  InputPasswordView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/29/25.
//

import SwiftUI

struct InputPasswordView: View {
    let placeholder: String
    let iconName: String
    let maxCount: Int?
    let showError: Binding<Bool>?
    
    @Binding var text: String
    
    @State private var secureText: Bool = true
    
    @FocusState private var focus: Bool
    
    private let textFieldHeight: CGFloat = 48
    
    init(_ placeholder: String, iconName: String, maxCount: Int? = nil, showError: Binding<Bool>? = nil, text: Binding<String>) {
        self.placeholder = placeholder
        self.iconName = iconName
        self.maxCount = maxCount
        self.showError = showError
        self._text = text
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: iconName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.gray60)
                    .padding(.leading)
                
                secureAnyView()
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(Color.gray60)
                    }
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity)
                    .frame(height: textFieldHeight)
                    .foregroundStyle(Color.gray80)
                    .padding(.leading, 8)
                    .padding(.trailing, 16)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onReceive(_text.wrappedValue.publisher.collect()) { output in
                        if let maxCount {
                            let s = String(output.prefix(maxCount))
                            if _text.wrappedValue != s && (maxCount != 0) {
                                _text.wrappedValue = s
                            }
                        }
                    }
                    .truncationMode(.middle)
                    .background(Color.clear)
                
                getTrailingImage()
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.gray30)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 12)
                    .onTapGesture {
                        secureText.toggle()
                    }
            }
            .background {
                Capsule()
                    .stroke(getStrokeColor(), lineWidth: 1)
                    .background(Color.white, in: .capsule)
            }
        }
    }
    
    private func secureAnyView() -> AnyView {
        if !secureText {
            return AnyView(
                TextField("", text: $text)
            )
        } else {
            return AnyView(
                SecureField("", text: $text)
            )
        }
    }
    
    private func getStrokeColor() -> Color {
        if showError?.wrappedValue ?? false {
            return Color.destructive60
        }
        
        return Color.gray30
    }
    
    private func getTrailingImage() -> Image {
        return secureText ? Image(systemName: "eye.slash") : Image(systemName: "eye")
    }
}

private struct PreviewView: View {
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            Color.gray5.ignoresSafeArea()
            
            InputPasswordView("Enter your password...", iconName: "lock", text: $password)
        }
    }
}

#Preview {
    PreviewView()
}
