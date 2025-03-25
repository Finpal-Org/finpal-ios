//
//  PaymentInformationView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/19/25.
//

import SwiftUI

struct PaymentInformationView: View {
    @ObservedObject var viewModel: ScannedReceiptViewModel
    
    @State private var isPaymentMethodSheetPresented: Bool = false
    
    var body: some View {
        ZStack {
            Color.gray5.ignoresSafeArea()
            
            VStack {
                
                HStack(spacing: 6) {
                    Text("Payment Method")
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                    
                    editButton
                }
                .padding(.horizontal, 16)
                
                VStack {
                    if let paymentType = viewModel.paymentType {
                        VStack {
                            paymentType.iconName
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 70)
                            
                            Text(paymentType.rawValue)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    } else {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .frame(width: 48, height: 48)
                                    .foregroundStyle(Color.destructive5)
                                
                                Image(systemName: "xmark")
                                    .imageScale(.large)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.destructive50)
                            }
                            
                            VStack(spacing: 12) {
                                Text("No payment method found")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text("You can manually enter or edit the payment method if needed.")
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(Color.gray60)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 178)
                .background(Color.white, in: .rect(cornerRadius: 24))
                .padding(.horizontal)
                .mediumShadow()
            }
        }
    }
    
    private var editButton: some View {
        Button("Edit") {
            isPaymentMethodSheetPresented = true
        }
        .font(.system(size: 14, weight: .medium))
        .sheet(isPresented: $isPaymentMethodSheetPresented) {
            PaymentEditView(paymentType: $viewModel.paymentType)
                .presentationDragIndicator(.visible)
        }
    }
    
    private func onEditButtonPressed() {
        isPaymentMethodSheetPresented = true
    }
    
}

#Preview {
    PaymentInformationView(viewModel: ScannedReceiptViewModel(receipt: .mock))
}
