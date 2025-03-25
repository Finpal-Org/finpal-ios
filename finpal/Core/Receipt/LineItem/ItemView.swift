//
//  ItemView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/19/25.
//

import SwiftUI

struct ItemView: View {
    @Binding var item: LineItemModel
    
    enum FocusedField {
        case quantity, description, price
    }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        HStack {
            TextField("-", value: $item.quantity, format: .number)
                .focused($focusedField, equals: .quantity)
                .keyboardType(.numberPad)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
                .padding()
                .frame(width: 55, height: 48)
                .background(
                    Capsule()
                        .stroke(Color.gray30, lineWidth: 1)
                        .fill(Color.white)
                )
            
            TextField("Item Name", text: $item.description)
                .focused($focusedField, equals: .description)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
                .padding()
                .frame(width: 220, height: 48)
                .background(
                    Capsule()
                        .stroke(Color.gray30, lineWidth: 1)
                        .fill(Color.white)
                )
            
            TextField("0.00", value: $item.total, format: .number.precision(.fractionLength(2)))
                .focused($focusedField, equals: .price)
                .keyboardType(.decimalPad)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
                .padding()
                .frame(width: 90, height: 48)
                .background(
                    Capsule()
                        .stroke(Color.gray30, lineWidth: 1)
                        .fill(Color.white)
                )
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    
                    Button {
                        focusedField = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
        }
    }
}

#Preview {
    ItemView(item: .constant(.mock))
}
