//
//  EditReceiptView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/4/25.
//

import SwiftUI

struct EditReceiptView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var invoiceNumber: String = ""
    @State private var vendorImage: UIImage?
    @State private var vendorName: String = ""
    @State private var receiptDate: Date = .now
    
    @State private var lineItems: [LineItemModel] = []
    @State private var isDatePickerShown = false
    @State private var isSavingChanges: Bool = false
    
    @State private var showPopup = false
    @State private var errorMessage = ""
    
    @Bindable var viewModel: ReceiptViewModel
    
    private let taxRate: Double = 0.15
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(Color.gray80)
                        .padding(16)
                        .onTapGesture {
                            onBackButtonPressed()
                        }
                    
                    Spacer()
                }
                
                titleSection
                
                VStack(alignment: .leading, spacing: 24) {
                    invoiceNumberView
                    
                    VendorLogoView(viewModel: viewModel)
                    
                    vendorNameView
                    
                    dateView
                    lineItemsView
                    paymentSummaryView
                    saveChangesView
                }
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
        .task {
            loadData()
        }
        .errorPopup(showingPopup: $showPopup, errorMessage)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Edit Receipt Details")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Text("Here you can edit your receipt information easily")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
        }
        .frame(maxWidth: .infinity)
        .padding([.vertical, .trailing])
    }
    
    private var vendorNameView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Vendor Name")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            InputTextFieldView(
                "Enter the vendor's name...",
                iconName: "storefront",
                text: $vendorName
            )
        }
        .padding(.horizontal, 16)
    }
    
    private var invoiceNumberView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Invoice Number")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            InputTextFieldView(
                "Enter the receipt's invoice number...",
                iconName: "number",
                text: $invoiceNumber
            )
        }
        .padding(.horizontal, 16)
    }
    
    private var dateView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
                .padding(.horizontal)
            
            EditReceiptDatePicker(
                iconName: "calendar",
                date: $receiptDate,
                showDatePicker: $isDatePickerShown
            )
        }
    }
    
    private var lineItemsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            LineItemView(lineItems: $lineItems)
            
            VStack {
                Divider()
                    .padding()
                
                HStack {
                    Image(systemName: "plus.circle")
                        .imageScale(.medium)
                    
                    Text("Add Item")
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                }
                .foregroundStyle(Color.accent)
                .padding(.horizontal)
                .onTapGesture {
                    onAddItemButtonPressed()
                }
            }
        }
    }
    
    private var paymentSummaryView: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 6) {
                Image(systemName: "creditcard")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.gray60)
                
                Text("Payment Summary")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.gray80)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Subtotal")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.gray60)
                    
                    Spacer()
                    
                    Text(calculateSubtotal())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                }
                
                Divider()
                
                HStack {
                    Text("VAT (15%)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.gray60)
                    
                    Spacer()
                    
                    Text(calculateTax())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.gray60)
                    
                    Spacer()
                    
                    Text(calculateTotalPrice())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .padding(.horizontal, 16)
            .background(Color.white, in: .rect(cornerRadius: 24))
            .padding(.horizontal, 16)
            .mediumShadow()
        }
        .padding(.vertical)
    }
    
    private var saveChangesView: some View {
        Group {
            if isSavingChanges {
                ProgressView()
                    .tint(.white)
            } else {
                Text("Save Changes")
            }
        }
        .callToActionButton()
        .padding(.horizontal)
        .anyButton(.press) {
            Task {
                await onSaveChangesPressed()
            }
        }
        .disabled(isSavingChanges ? true : false)
    }
    
    private func loadData() {
        self.invoiceNumber = viewModel.invoiceNumber
        self.vendorImage = viewModel.vendorImage
        self.vendorName = viewModel.vendorName
        self.receiptDate = viewModel.date
        self.lineItems = viewModel.lineItems
    }
    
    private func onAddItemButtonPressed() {
        let randomNumber = Int.random(in: 1_000_000_000...9_999_999_999)
        
        let newItem = LineItemModel(
            id: randomNumber,
            quantity: 1,
            description: "Item Name",
            total: 0.00
        )
        
        lineItems.append(newItem)
    }
    
    private func onSaveChangesPressed() async {
        isSavingChanges = true
        
        if invoiceNumber.isEmpty {
            errorMessage = "Please enter an invoice number before saving."
            showPopup = true
            
            isSavingChanges = false
            return
        }
        
        if vendorName.isEmpty || vendorName == "Not Found" {
            errorMessage = "Please enter a vendor name."
            showPopup = true
            
            isSavingChanges = false
            return
        }
        
        if lineItems.isEmpty {
            errorMessage = "Please add at least one item to the receipt."
            showPopup = true
            
            isSavingChanges = false
            return
        }
        
        lineItems.forEach { item in
            if item.quantity <= 0 {
                errorMessage = "Items must have a quantity greater than 0."
                showPopup = true
                
                isSavingChanges = false
                return
            }
            
            if item.description.isEmpty {
                errorMessage = "Items must have a name."
                showPopup = true
                
                isSavingChanges = false
                return
            }
            
            if item.description == "Item Name" {
                errorMessage = "Please enter a valid item name."
                showPopup = true
                
                isSavingChanges = false
                return
            }
            
            if item.total <= 0 {
                errorMessage = "Items must have a total amount greater than 0."
                showPopup = true
                
                isSavingChanges = false
                return
            }
            
            if item.description == "Item Name" && item.quantity == 1 && item.total == 0.00 {
                errorMessage = "Please update the default item with correct name, quantity, and total."
                showPopup = true
                
                isSavingChanges = false
                return
            }
        }

        try? await Task.sleep(for: .seconds(2))
        
        viewModel.invoiceNumber = invoiceNumber
        viewModel.vendorName = vendorName
        viewModel.date = receiptDate
        viewModel.lineItems = lineItems

        isSavingChanges = false
        dismiss()
    }
    
    private func onBackButtonPressed() {
        dismiss()
    }
    
    private func calculateSubtotal() -> String {
        var subtotal: Float = 0
        
        lineItems.forEach { item in
            subtotal += Float(item.quantity) * Float(item.total)
        }
        
        return getPrice(value: subtotal)
    }
    
    private func calculateTax() -> String {
        var subtotal: Float = 0
        
        lineItems.forEach { item in
            subtotal += Float(item.quantity) * Float(item.total)
        }
        
        let tax = subtotal * Float(taxRate)
        
        return getPrice(value: tax)
    }
    
    private func calculateTotalPrice() -> String {
        var subtotal: Float = 0
        
        lineItems.forEach { item in
            subtotal += Float(item.quantity) * Float(item.total)
        }
        
        let tax = subtotal * Float(taxRate)
        let total = subtotal + tax
        
        return getPrice(value: total)
    }
    
    private func getPrice(value: Float) -> String {
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format.string(from: NSNumber(value: value)) ?? ""
    }
}

private struct PreviewView: View {
    @State private var viewModel = ReceiptViewModel(scannedReceipt: .mock)
    
    var body: some View {
        EditReceiptView(viewModel: viewModel)
    }
}

#Preview {
    PreviewView()
}
