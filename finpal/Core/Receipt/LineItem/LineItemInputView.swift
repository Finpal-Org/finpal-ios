//
//  LineItemInputView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/13/25.
//

import SwiftUI

struct LineItemInputView: View {
    @Binding var quantity: Int
    @Binding var name: String
    @Binding var price: Double
    
    @State private var quantityText: String = ""
    @State private var priceText: String = ""
    
    @State private var error: Bool = false
    
    var body: some View {
        HStack {
            LineItemTextField(
                "-x",
                maxCount: 3,
                keyboardType: .numberPad,
                text: $quantityText,
                error: $error
            )
            .frame(width: 55)
            .onChange(of: quantityText) { _, newValue in
                quantity = Int(newValue) ?? 0
                print(quantity)
            }
            
            LineItemTextField(
                "Item Name",
                text: $name,
                error: $error
            )
            .frame(width: 220)
            
            LineItemTextField(
                "0.00",
                maxCount: 5,
                keyboardType: .decimalPad,
                text: $priceText,
                error: $error
            )
            .frame(width: 90)
            .onChange(of: priceText) { _, newValue in
                price = Double(newValue) ?? 0.00
                print(price)
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        self.quantityText = "\(quantity)"
        self.priceText = "\(price)"
    }
}

private struct LineItemTextField: View {
    private var placeholder: String
    private var maxCount: Int?
    private var keyboardType: UIKeyboardType?
    private var text: Binding<String>
    private var error: Binding<Bool>?
    
    init(
        _ placeholder: String,
        maxCount: Int? = nil,
        keyboardType: UIKeyboardType? = nil,
        text: Binding<String>,
        error: Binding<Bool>? = nil
    ) {
        self.placeholder = placeholder
        self.maxCount = maxCount
        self.keyboardType = keyboardType
        self.text = text
        self.error = error
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TextField("", text: text)
                    .placeholder(when: text.wrappedValue.isEmpty) {
                        Text(placeholder)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(Color.gray40)
                    }
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .foregroundStyle(Color.gray80)
                    .padding([.leading, .trailing], 12)
                    .autocorrectionDisabled()
                    .keyboardType(keyboardType ?? .default)
                    .onReceive(text.wrappedValue.publisher.collect()) { output in
                        if let maxCount {
                            let s = String(output.prefix(maxCount))
                            if text.wrappedValue != s && (maxCount != 0) {
                                text.wrappedValue = s
                            }
                        }
                    }
                    .truncationMode(.tail)
                    .background(Color.clear)
            }
            .background {
                Capsule()
                    .stroke(getBorderColor(), lineWidth: 1)
                    .background(Color.white, in: .capsule)
            }
        }
    }
    
    private func getBorderColor() -> Color {
        if error?.wrappedValue ?? false {
            return Color.destructive60
        } else {
            return Color.gray30
        }
    }
}

private struct PreviewView: View {
    @State private var quantity = 2
    @State private var name = ""
    @State private var price = 5.40
    
    var body: some View {
        LineItemInputView(
            quantity: $quantity,
            name: $name,
            price: $price
        )
    }
}

#Preview {
    PreviewView()
}
