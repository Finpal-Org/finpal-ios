//
//  TransactionAmountInputView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import SwiftUI

struct TransactionAmountInputView: View {
    var body: some View {
        VStack {
            HStack {
                Text("SAR")
                    .font(.system(size: 30, weight: .regular))
                    .foregroundStyle(Color.gray40)
                
                Text("0.00")
                    .font(.system(size: 60, weight: .semibold))
                    .foregroundStyle(Color.gray80)
            }
            
            Divider()
                .padding(.horizontal)
        }
    }
}

#Preview {
    TransactionAmountInputView()
}
