//
//  GoalAmountInputView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/5/25.
//

import SwiftUI

struct GoalAmountInputView: View {
    @Binding var page: Int
    @Binding var amount: Int
    
    var body: some View {
        VStack {
            Text("How much do you want to save in total?")
                .multilineTextAlignment(.leading)
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color.gray80)
                .tracking(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack(spacing: 0) {
                HStack(alignment: .bottom, spacing: 4) {
                    Text("SAR")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundStyle(Color.gray40)
                        .padding(.bottom, 6)
                    
                    TextField("0", value: $amount, formatter: NumberFormatter())
                        .font(.system(size: 60, weight: .semibold))
                        .foregroundStyle(Color.brand60)
                        .keyboardType(.numberPad)
                        .minimumScaleFactor(0.1)
                }
                
                Divider()
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12) {
                HStack {
                    Text("Continue")
                    
                    Image(systemName: "arrow.right")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(amount <= 0 ? Color.brand30 : Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(amount <= 0 ? Color.brand10 : Color.brand60)
                .clipShape(.capsule)
                .frame(width: 142)
                .anyButton(.press) {
                    page += 1
                }
                .disabled(amount <= 0)
                
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
    @Previewable @State var amount = 0
    GoalAmountInputView(page: .constant(2), amount: $amount)
}
