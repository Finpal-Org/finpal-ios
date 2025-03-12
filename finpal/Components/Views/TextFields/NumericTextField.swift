//
//  NumericTextField.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/6/25.
//

import SwiftUI

enum NumericTextInputMode {
    case number, decimal
}

struct NumericTextInputViewModifier: ViewModifier {
    @Binding var text: String
    
    let mode: NumericTextInputMode
    
    func body(content: Content) -> some View {
        content
            .keyboardType(mode == .number ? .numberPad : .decimalPad)
            .onChange(of: text) { oldValue, newValue in
                let decimalSeparator: String = Locale.current.decimalSeparator ?? "."
                let numbers = "0123456789\(mode == .decimal ? decimalSeparator : "")"
                
                if newValue.components(separatedBy: decimalSeparator).count - 1 > 1 {
                    text = String(newValue.dropLast())
                } else {
                    let filtered = newValue.filter { numbers.contains($0) }
                    if filtered != newValue {
                        text = filtered
                    }
                }
            }
    }
}

struct NumericTextField<Value: Numeric>: View {
    let title: String
    let mode: NumericTextInputMode
    
    @Binding var value: Value
    
    @State private var text: String = ""
    
    init(_ title: String, mode: NumericTextInputMode = .number, value: Binding<Value>) {
        self.title = title
        self.mode = mode
        self._value = value
    }
    
    var body: some View {
        TextField(title,
                  text: $text,
                  prompt: Text("\(value)").font(.system(size: 16, weight: .regular)).foregroundStyle(Color.gray60)
        )
        .numericTextInput(mode, text: $text)
        .onChange(of: text) { _, newValue in
            guard let numericValue = newValue as? Value else { return }
            value = numericValue
        }
    }
}

private struct PreviewView: View {
    @State private var intValue: Int = 0
    @State private var doubleValue: Double = 0.0
    
    var body: some View {
        VStack {
            NumericTextField("Int", value: $intValue)
            
            NumericTextField("Double", mode: .decimal, value: $doubleValue)
        }
        .padding()
        .textFieldStyle(.roundedBorder)
    }
}

#Preview {
    PreviewView()
}
