//
//  LineItemRowView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/5/25.
//

import SwiftUI

struct LineItemRowView: View {
    @Binding var lineItem: LineItem
    
    enum FocusedField {
        case quantity
        case description
        case price
    }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        HStack {
            NumericTextField("-", value: $lineItem.quantity)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
                .focused($focusedField, equals: .quantity)
                .padding()
                .frame(width: 55, height: 48)
                .background(
                    Capsule()
                        .stroke(Color.gray30, lineWidth: 1)
                        .fill(Color.white)
                )
            
            TextField("Item Name", text: $lineItem.description)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
                .focused($focusedField, equals: .description)
                .padding()
                .frame(width: 220, height: 48)
                .background(
                    Capsule()
                        .stroke(Color.gray30, lineWidth: 1)
                        .fill(Color.white)
                )
            
            NumericTextField("0.00", mode: .decimal, value: $lineItem.total)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
                .focused($focusedField, equals: .price)
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
                Spacer()
            }
            
            ToolbarItem(placement: .keyboard) {
                Button {
                    focusedField = nil
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
    }
}

private struct PreviewView: View {
    @State private var lineItems: [LineItem] = LineItem.mocks
    
    var body: some View {
        ZStack {
            Color.gray5.ignoresSafeArea()
            
            VStack {
                ForEach($lineItems) { $item in
                    LineItemRowView(lineItem: $item)
                }
            }
        }
    }
}

#Preview {
    PreviewView()
}
