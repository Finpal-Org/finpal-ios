//
//  ReceiptDetailsView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/20/25.
//

import SwiftUI

struct ReceiptDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    
    let receipt: ReceiptModel
    
    @State private var isPresented = false
    @State private var transitionSource: Int = 0
    
    @Namespace private var animation
    
    var body: some View {
        ScrollView {
            VStack {
                headerView
                otherDetailsSection
                lineItemsSection
                noteSection
                receiptImageSection
                deleteButton
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.all)
        .navigationDestination(isPresented: $isPresented) {
            receiptImageDestination
        }
    }
    
    private var navigationBar: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray80)
                .anyButton {
                    onBackButtonPressed()
                }
            
            Spacer()
            
            Text("Receipt Details")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.gray80)
                .padding(.trailing, 14)
            
            Spacer()
        }
        .padding(.top, 60)
        .padding(.horizontal, 16)
    }
    
    private var headerView: some View {
        VStack(spacing: 24) {
            // Navigation Bar
            navigationBar
            
            VStack(spacing: 20) {
                vendorHeaderView
                
                VStack(spacing: 12) {
                    Text(receipt.dateText)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.gray60)
                    
                    Text(receipt.vendor?.name ?? "")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.gray80)
                }
                
                Text(receipt.total, format: .currency(code: "SAR"))
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                
                HStack(spacing: 6) {
                    Image(systemName: receipt.category.iconName)
                    
                    Text(receipt.category.rawValue)
                        
                }
                .font(.system(size: 14, weight: .medium))
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .foregroundStyle(Color.brand60)
                .background {
                    Capsule()
                        .stroke(Color.brand60, lineWidth: 1)
                        .background(Color.clear, in: .capsule)
                }
            }
            
            Spacer()
            
        }
        .frame(height: 475)
        .background(Color.brand10)
    }
    
    private var vendorHeaderView: some View {
        ZStack {
            if let vendor = receipt.vendor, let vendorLogoURL = vendor.logoURL {
                ImageLoaderView(urlString: vendorLogoURL)
            } else {
                Rectangle()
                    .fill(Color.gray)
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(.circle)
    }
    
    private var otherDetailsSection: some View {
        VStack {
            
            VStack(spacing: 0) {
                invoiceNumberSection
                subtotalSection
                taxSection
                paymentTypeSection
            }
            
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 24))
        .padding(.horizontal, 16)
        .offset(x: 0, y: -80)
        .mediumShadow()
    }
    
    private var invoiceNumberSection: some View {
        VStack {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.gray5)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "number")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    
                    Text("Invoice Number")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                }
                
                Spacer()
                
                Text(receipt.invoiceNumber)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.gray80)
            }
            .padding(12)
            
            Divider()
        }
    }
    
    private var subtotalSection: some View {
        VStack {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.gray5)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "banknote")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    
                    Text("Subtotal")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                }
                
                Spacer()
                
                Text(receipt.subtotal, format: .currency(code: "SAR"))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.gray80)
            }
            .padding(12)
            
            Divider()
        }
    }
    
    private var taxSection: some View {
        VStack {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.gray5)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "percent")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    
                    Text("Tax (15%)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                }
                
                Spacer()
                
                Text(receipt.tax, format: .currency(code: "SAR"))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.gray80)
            }
            .padding(12)
            
            Divider()
        }
    }
    
    private var paymentTypeSection: some View {
        HStack {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .foregroundStyle(Color.gray5)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "creditcard")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.gray60)
                }
                
                Text("Payment Method")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.gray80)
            }
            
            Spacer()
            
            Text(receipt.payment.displayName ?? "")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.gray80)
        }
        .padding(12)
    }
    
    private var lineItemsSection: some View {
        VStack(alignment: .leading) {
            Text("Items")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.horizontal, 16)
            
            VStack {
                ForEach(receipt.lineItems) { item in
                    VStack {
                        HStack {
                            Text("\(item.quantity)x")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(Color.gray60)
                            
                            Text(item.description)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.gray80)
                            
                            Spacer()
                            
                            Text(item.total, format: .currency(code: "SAR"))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.gray80)
                        }
                        
                        if item != receipt.lineItems.last {
                            Divider()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 24))
            .padding(.horizontal, 16)
            .mediumShadow()
        }
        .offset(x: 0, y: -42)
    }
    
    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Note")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.horizontal, 16)
            
            VStack {
                Text(receipt.note)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.gray60)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 150, alignment: .top)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 24))
            .padding(.horizontal, 16)
            .mediumShadow()
        }
        .offset(x: 0, y: -12)
    }
    
    private var receiptImageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Receipt Image")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                if let imageName = receipt.imageName {
                    ImageLoaderView(urlString: imageName)
                } else {
                    Rectangle()
                        .fill(Color.gray)
                }
            }
            .frame(height: 170)
            .clipShape(.rect(cornerRadius: 24))
            .padding(.horizontal, 32)
            .frame(maxWidth: .infinity, alignment: .center)
            .anyButton {
                isPresented = true
            }
        }
        .offset(x: 0, y: 32)
    }
    
    private var receiptImageDestination: some View {
        ZStack {
            if let imageName = receipt.imageName {
                ImageLoaderView(urlString: imageName)
            } else {
                Rectangle()
                    .fill(Color.gray)
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(.black)
                .ignoresSafeArea()
        }
        .overlay {
            VStack {
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                        .padding(10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 0)
            }
            .padding(16)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
    
    private var deleteButton: some View {
        HStack(spacing: 8) {
            Image(systemName: "trash")
                .font(.system(size: 16))
            
            Text("Delete Receipt")
                .font(.system(size: 14, weight: .semibold))
        }
        .foregroundStyle(Color.destructive60)
        .padding(.bottom, 180)
        .offset(x: 0, y: 100)
        .anyButton {
            
        }
    }
    
    private func onBackButtonPressed() {
        dismiss()
    }
}

#Preview {
    ReceiptDetailsView(receipt: .mock)
}
