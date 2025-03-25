//
//  PaymentEditView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/19/25.
//

import SwiftUI

struct PaymentEditView: View {
    @Binding var paymentType: PaymentType?
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPaymentMethod: PaymentType?
    @State private var showingError: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Select Payment Method")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.gray80)
                
                Spacer()
                
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(Color.gray60)
                    .onTapGesture {
                        onXMarkButtonPressed()
                    }
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 12) {
                ForEach(PaymentType.allCases, id: \.self) { type in
                    PaymentMethodRow(type: type, selectedPaymentMethod: $selectedPaymentMethod)
                        .onTapGesture {
                            onPaymentMethodPressed(type: type)
                        }
                }
            }
            
            setPaymentButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    private var setPaymentButton: some View {
        VStack(spacing: 16) {
            if showingError {
                ErrorBoxView("Select a payment method!")
                    .transition(.slide)
            }
            
            HStack {
                Text("Set Payment Method")
                
                Image(systemName: "checkmark")
            }
            .callToActionButton()
            .anyButton(.press) {
                onSetPaymentMethodButtonPressed()
            }
        }
        .padding()
        .animation(.easeInOut, value: showingError)
    }
    
    private func onPaymentMethodPressed(type: PaymentType) {
        withAnimation {
            if selectedPaymentMethod != nil && selectedPaymentMethod == type {
                selectedPaymentMethod = nil
            } else {
                selectedPaymentMethod = type
                showingError = false
            }
        }
    }
    
    private func onSetPaymentMethodButtonPressed() {
        if selectedPaymentMethod != nil {
            paymentType = selectedPaymentMethod
            dismiss()
        } else {
            showingError = true
        }
    }
    
    private func onXMarkButtonPressed() {
        dismiss()
    }
}

private struct PaymentMethodRow: View {
    let type: PaymentType
    
    @Binding var selectedPaymentMethod: PaymentType?
    
    var body: some View {
        HStack(spacing: 12) {
            type.iconName
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundStyle(.accent)
            
            Text(type.rawValue)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(Color.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 72)
        .padding(.horizontal)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(selectedPaymentMethod == type ? Color.brand60 : Color.clear, lineWidth: 1)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(selectedPaymentMethod == type ? Color.brand5 : Color.gray5)
        )
        .padding(.horizontal)
        .scaleEffect(selectedPaymentMethod == type ? 1.02 : 1.0)
    }
}

#Preview {
    PaymentEditView(paymentType: .constant(.mastercard))
}
