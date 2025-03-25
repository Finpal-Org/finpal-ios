//
//  NameInputView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/24/25.
//

import SwiftUI

struct FinpalProgressViewStyle: ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .accentColor(Color.brand60)
            .frame(height: 8.0)
            .scaleEffect(x: 1, y: 2, anchor: .center)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .padding(.horizontal)
    }
}

struct NameInputView: View {
    @State private var fullName: String = ""
    
    var body: some View {
        VStack {
            toolbarView
            
            Spacer()
            
            textFieldView
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
    }
    
    private var toolbarView: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray80)
            
            ProgressView(value: 0.8)
                .progressViewStyle(FinpalProgressViewStyle())
            
            Text("Skip")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.brand60)
                .anyButton {
                    
                }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private var textFieldView: some View {
        VStack(spacing: 64) {
            Text("Please enter your full \nname")
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            TextField("Full Name", text: $fullName)
                .multilineTextAlignment(.center)
                .autocorrectionDisabled()
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color.gray60)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .padding(.horizontal, 16)
                .overlay {
                    Capsule()
                        .strokeBorder(Color.gray30, lineWidth: 1)
                }
                .padding(.horizontal)
            
            HStack {
                Text("Continue")
                
                Image(systemName: "arrow.right")
            }
            .callToActionButton()
            .anyButton(.press) {
                
            }
            .padding()
        }
    }
}

#Preview {
    NameInputView()
}
