//
//  ReceiptView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/3/25.
//

import SwiftUI
import MapKit

struct ReceiptView: View {
    @Environment(ReceiptManager.self) private var receiptManager
    
    @StateObject private var viewModel: ScannedReceiptViewModel
    
    @State private var noteText: String = ""
    @State private var isSaving: Bool = false
    @State private var showingError: Bool = false
    
    init(receipt: ReceiptModel) {
        self._viewModel = StateObject(wrappedValue: ScannedReceiptViewModel(receipt: receipt))
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
                    
                    PaymentInformationView(viewModel: viewModel)
                    
                    WarrantySectionView()
                }
                
                buttonsSection
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
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
            HStack {
                Text("Save Receipt")
                
                Image(systemName: "checkmark")
            }
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
        isSaving = true
        
        Task {
            do {
                guard let receiptId = Int(viewModel.receiptId) else {
                    showingError = true
                    isSaving = false
                    return
                }
                
                guard let vendorName = viewModel.vendorName, !vendorName.isEmpty else {
                    showingError = true
                    isSaving = false
                    return
                }
                
                guard let vendorLogo = viewModel.vendorLogo, let logoData = vendorLogo.jpegData(compressionQuality: 0.9) else {
                    showingError = true
                    isSaving = false
                    return
                }
                
                let vendor = await PhotoViewModel.saveImage(
                    receiptId: viewModel.receiptId,
                    vendorName: vendorName,
                    data: logoData
                )
                
                let receipt = ReceiptModel(
                    id: receiptId,
                    category: viewModel.category?.rawValue,
                    date: viewModel.date.description,
                    invoiceNumber: viewModel.invoiceNumber,
                    isDuplicate: false,
                    lineItems: viewModel.lineItems,
                    payment: viewModel.getPayment(),
                    subtotal: viewModel.subtotal,
                    tax: viewModel.tax,
                    total: viewModel.total,
                    vendor: vendor
                )
                
                try await receiptManager.createNewReceipt(receipt: receipt)
                
            } catch {
                print("[finpal - ERROR] Failed to save receipt: \(error.localizedDescription)")
            }
            
            isSaving = false
        }
    }
}

private struct PreviewView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray5.ignoresSafeArea()
                
                ReceiptView(receipt: .mock)
            }
            .toolbar(.hidden)
        }
    }
}

#Preview {
    PreviewView()
        .previewEnvironment()
}
