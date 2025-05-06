//
//  GoalNameInputView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/5/25.
//

import SwiftUI

struct GoalNameInputView: View {
    @Binding var page: Int
    
    private var text: Binding<String>
    
    init(page: Binding<Int>, text: Binding<String>) {
        self._page = page
        self.text = text
    }
    
    var body: some View {
        VStack {
            Text("What should we name this goal?")
                .multilineTextAlignment(.leading)
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color.gray80)
                .tracking(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack(spacing: 0) {
                TextField("Enter your goal name...", text: text)
                    .multilineTextAlignment(.center)
                    .autocorrectionDisabled()
                    .font(.system(size: 24, weight: .regular))
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .foregroundStyle(Color.gray60)
                    .padding(.horizontal, 16)
                    .tracking(1)
                    .background {
                        Capsule()
                            .stroke(Color.gray30, lineWidth: 1)
                            .background(Color.white, in: .capsule)
                    }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12) {
                HStack {
                    Text("Continue")
                    
                    Image(systemName: "arrow.right")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(text.wrappedValue.isEmpty ? Color.brand30 : Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(text.wrappedValue.isEmpty ? Color.brand10 : Color.brand60)
                .clipShape(.capsule)
                .frame(width: 142)
                .anyButton(.press) {
                    page += 1
                }
                .disabled(text.wrappedValue.isEmpty)
                
                HStack {
                    Image(systemName: "chevron.left")
                    
                    Text("No, Go Back")
                }
                .secondaryButton()
                .frame(width: 162)
                .anyButton(.press) {
                    page -= 1
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    @Previewable @State var text = ""
    GoalNameInputView(page: .constant(1), text: $text)
}
