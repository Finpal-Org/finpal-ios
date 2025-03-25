//
//  EditReceiptView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/4/25.
//

import SwiftUI

struct EditReceiptView: View {
    @State var vendorName: String
    @State var receiptDate: Date
    
    @State private var isDatePickerShown = false
    @State private var isSavingChanges: Bool = false
    
    @ObservedObject var viewModel: ScannedReceiptViewModel
    
    @StateObject private var lineItems: LineItemViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: ScannedReceiptViewModel) {
        self.vendorName = viewModel.vendorName ?? "Not Set"
        self.receiptDate = viewModel.date
        self.viewModel = viewModel
        self._lineItems = StateObject(wrappedValue: LineItemViewModel(items: viewModel.lineItems))
    }
    
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
                    VendorLogoView(vendorLogo: $viewModel.vendorLogo)
                    
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
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.horizontal)
            
            EditReceiptTextField(iconName: "storefront", text: $vendorName)
        }
    }
    
    private var dateView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date")
                .font(.system(size: 16, weight: .bold))
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
            LineItemView(viewModel: lineItems)
            
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
                    withAnimation(.smooth) {
                        lineItems.addItem()
                    }
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
                    
                    Text(lineItems.calculateSubtotal())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                }
                
                Divider()
                
                HStack {
                    Text("VAT (15%)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.gray60)
                    
                    Spacer()
                    
                    Text(lineItems.calculateTax())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.gray60)
                    
                    Spacer()
                    
                    Text(lineItems.calculateTotalPrice())
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
    
    private func onSaveChangesPressed() async {
        isSavingChanges = true

        try? await Task.sleep(for: .seconds(2))
        
        viewModel.vendorName = vendorName
        viewModel.date = receiptDate
        viewModel.lineItems = lineItems.items

        isSavingChanges = false
        dismiss()
    }
    
    private func onBackButtonPressed() {
        dismiss()
    }
}

private struct PreviewView: View {
    @StateObject private var viewModel = ScannedReceiptViewModel(receipt: .mock)
    
    var body: some View {
        EditReceiptView(viewModel: viewModel)
    }
}

#Preview {
    PreviewView()
}
