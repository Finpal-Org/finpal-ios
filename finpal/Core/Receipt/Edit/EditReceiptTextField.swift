//
//  EditReceiptTextField.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/14/25.
//

import SwiftUI

struct EditReceiptTextField: View {
    let iconName: String
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .imageScale(.medium)
                .fontWeight(.semibold)
                .foregroundStyle(Color.gray60)
            
            TextField(text, text: $text)
                .font(.callout)
                .foregroundStyle(Color.gray60)
                .autocorrectionDisabled()
            
            Spacer()
            
            Image(systemName: "pencil.line")
                .imageScale(.large)
                .fontWeight(.semibold)
                .foregroundStyle(Color.gray30)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(
            Capsule()
                .stroke(Color.gray30, lineWidth: 1)
                .fill(Color.white)
        )
        .padding(.horizontal)
    }
}

#Preview {
    EditReceiptTextField(iconName: "envelope", text: .constant(""))
}
