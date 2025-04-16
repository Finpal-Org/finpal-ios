//
//  ReceiptView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/3/25.
//

import SwiftUI

struct ReceiptView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @Environment(ReceiptManager.self) private var receiptManager
    @Environment(TabBarViewModel.self) private var tabBar
    
    @State private var viewModel: ReceiptViewModel
    
    @State private var noteText: String = ""
    
    @State private var showPopup = false
    @State private var errorMessage = ""
    
    @State private var showSavePopup = false
    @State private var showSaveError = false
    @State private var showSaveResult = false
    
    init(scannedReceipt: ReceiptModel) {
        self.viewModel = ReceiptViewModel(scannedReceipt: scannedReceipt)
    }
    
    var body: some View {
        VStack {
            receiptDetailsToolbar
            
            ScrollView {
                ReceiptDataView(viewModel: viewModel)
                
                Divider()
                    .padding(.vertical, 24)
                
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        CategoryButtonView(selectedCategory: $viewModel.category)
                        
                        NoteButtonView(noteText: $noteText)
                    }
                    
                    PaymentInformationView(paymentType: $viewModel.paymentType)
                    
                    WarrantySectionView()
                }
                
                buttonsSection
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
        .blur(radius: showSavePopup ? 4 : 0)
        .disabled(showSavePopup ? true : false)
        .errorPopup(showingPopup: $showPopup, errorMessage)
        .savePopup(isPresented: $showSavePopup, error: $showSaveError, result: $showSaveResult)
    }
    
    private var receiptDetailsToolbar: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            NavigationLink {
                EditReceiptView(viewModel: viewModel)
                    .navigationBarBackButtonHidden()
            } label: {
                Image(systemName: "square.and.pencil")
            }
        }
        .font(.system(size: 20, weight: .medium))
        .overlay {
            Text("Scanned Receipt")
                .font(.system(size: 16, weight: .semibold))
        }
        .foregroundStyle(Color.gray80)
        .padding(16)
    }
    
    private var buttonsSection: some View {
        VStack {
            ZStack {
                if showSavePopup {
                    ProgressView()
                        .tint(.white)
                } else {
                    HStack {
                        Text("Save Receipt")
                        
                        Image(systemName: "checkmark")
                    }
                }
            }
            .disabled(showSavePopup ? true : false)
            .callToActionButton()
            .anyButton(.press) {
                onSavePressed()
            }
            .padding([.horizontal, .top])
            
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Delete Receipt")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(Color.destructive60)
            }
            .padding()
        }
    }
    
    private func onSavePressed() {
        showSavePopup = true
        
        Task {
            do {
                if viewModel.vendorImage == nil {
                    guard let vendorLogo = viewModel.vendorLogo else {
                        showSavePopup = false
                        errorMessage = "Please set the vendor image before saving the receipt."
                        showPopup = true
                        return
                    }
                    
                    try await viewModel.loadImageFromURL(from: vendorLogo)
                }
                
                guard let vendorImage = viewModel.vendorImage else {
                    showSavePopup = false
                    errorMessage = "Please set the vendor image before saving the receipt."
                    showPopup = true
                    return
                }
                
                let uid = try authManager.getAuthId()
                let paymentType = viewModel.paymentType ?? .mada
                
                let payment = PaymentModel(
                    displayName: paymentType.rawValue,
                    type: PaymentType.paymentTypeToString(from: paymentType)
                )
                
                let receipt = ReceiptModel(
                    receiptId: UUID().uuidString,
                    category: viewModel.category?.rawValue,
                    date: viewModel.date?.description,
                    invoiceNumber: viewModel.invoiceNumber,
                    isDuplicate: false,
                    lineItems: viewModel.lineItems,
                    payment: payment,
                    subtotal: viewModel.subtotal,
                    tax: viewModel.tax,
                    total: viewModel.total,
                    vendor: nil,
                    authorId: uid,
                    note: noteText
                )
                
                try await receiptManager.createNewReceipt(
                    receipt: receipt,
                    vendorName: viewModel.vendorName,
                    vendorLogo: vendorImage
                )
                
                showSaveResult = true
                
                try await Task.sleep(for: .seconds(8))
                
                showSavePopup = false
                
                try await Task.sleep(for: .seconds(1))
                
                tabBar.showLens = false
                tabBar.updateCurrentTab(.receipts)
                
            } catch {
                print("[finpal - ERROR] Could not save a receipt. \(error.localizedDescription)")
                showSaveResult = false
            }
            
            showSavePopup = false
        }
    }
}

private struct PreviewView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray5.ignoresSafeArea()
                
                ReceiptView(scannedReceipt: .mock)
            }
            .toolbar(.hidden)
        }
    }
}

#Preview {
    PreviewView()
        .previewEnvironment()
}
