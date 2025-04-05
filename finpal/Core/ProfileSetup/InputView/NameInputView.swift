//
//  NameInputView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/24/25.
//

import SwiftUI

struct NameInputView: View {
    var size: CGSize
    
    @Binding var currentIndex: Int
    @Binding var fullName: String
    
    var body: some View {
        VStack {
            Spacer()
            
            textFieldView
            
            Spacer()
        }
    }
    
    private var textFieldView: some View {
        VStack(spacing: 64) {
            Text("Please enter your full \nname")
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
                .addTitleAnimation(size: size, index: 0, currentIndex: currentIndex)
            
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
                .addSubtitleAnimation(size: size, index: 0, currentIndex: currentIndex)
            
            HStack {
                Text("Continue")
                
                Image(systemName: "arrow.right")
            }
            .callToActionButton()
            .anyButton(.press) {
                currentIndex += 1
            }
            .padding()
            .addButtonAnimation(size: size, index: 0, currentIndex: currentIndex)
        }
    }
}

#Preview {
    @Previewable @State var currentIndex: Int = 0
    @Previewable @State var fullName: String = ""
    
    GeometryReader { geometry in
        let size = geometry.size
        
        NameInputView(size: size, currentIndex: $currentIndex, fullName: $fullName)
    }
}
