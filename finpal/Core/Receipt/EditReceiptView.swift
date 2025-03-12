//
//  EditReceiptView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/4/25.
//

import SwiftUI

struct EditReceiptView: View {
    @State private var receipt: ReceiptData
    @State private var vendorName: String
    @State private var receiptDate: Date
    @State private var lineItems: [LineItem]
    @State private var editSubtotal: Double
    
    @State private var isDatePickerShown = false
    
    init(receipt: ReceiptData) {
        self.receipt = receipt
        self.vendorName = receipt.vendor.name
        self.receiptDate = receipt.date
        self.lineItems = receipt.lineItems
        self.editSubtotal = receipt.subtotal
    }
    
    var body: some View {
        ZStack {
            Color.gray5.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Edit Receipt Information")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(Color.gray80)
                        
                        Text("Here you can edit your receipt information easily")
                            .font(.callout)
                            .foregroundStyle(Color.gray60)
                    }
                    .padding()
                    
                    VStack(spacing: 24) {
                        vendorNameView
                        dateView
                        lineItemsView
                        saveChangesView
                    }
                }
            }
        }
    }
    
    private var vendorNameView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Vendor Name")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
                .padding(.horizontal)
            
            EditReceiptTextField(iconName: "storefront", text: $vendorName)
        }
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
            Text("Items")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
                .padding()
            
            if lineItems.isEmpty {
                Text("No items added yet.")
                    .font(.callout)
                    .foregroundStyle(Color.gray60)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                
                HStack {
                    Text("QTY")
                        .padding(.leading, 22)
                    
                    Text("DESC")
                        .padding(.leading, 24)
                    
                    Spacer()
                    
                    Text("AMT")
                        .padding(.trailing, 40)
                }
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color.gray40)
                
                LazyVStack(spacing: 12) {
                    ForEach(Array(lineItems.enumerated()), id: \.element.id) { index, item in
                        SwipeItem(
                            content: {
                                LineItemRowView(lineItem: $lineItems[index])
                            },
                            left: {
                                ZStack {
                                    
                                }
                            },
                            right: {
                                ZStack {
                                    Capsule()
                                        .fill(Color.destructive60)
                                    
                                    Image(systemName: "trash.circle")
                                        .foregroundColor(.white)
                                        .font(.largeTitle)
                                }
                                .onTapGesture {
                                    deleteItem(at: item.id)
                                }
                            },
                            itemHeight: 50
                        )
                        .frame(height: 50)
                    }
                }
            }
            
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
                        addItem()
                    }
                }
            }
        }
    }
    
    private var saveChangesView: some View {
        Text("Save Changes")
            .callToActionButton()
            .anyButton(.press) {
                
            }
            .padding()
    }
    
    private func onSaveChangesPressed() {
        receipt = ReceiptData(
            id: receipt.id,
            category: receipt.category,
            currencyCode: receipt.currencyCode,
            dateString: receiptDate.description,
            documentType: receipt.documentType,
            imageURL: receipt.imageURL,
            invoiceNumber: receipt.invoiceNumber,
            lineItems: lineItems,
            subtotal: receipt.subtotal,
            tax: receipt.tax,
            total: receipt.total,
            vendor: receipt.vendor
        )
    }
    
    private func addItem() {
        let newItem = LineItem(id: lineItems.count + 1, quantity: 1, description: "Item Name", total: 0.00)
        lineItems.append(newItem)
    }
    
    private func deleteItem(at id: Int?) {
        guard let id, let index = lineItems.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        lineItems.remove(at: index)
    }
    
}

struct EditReceiptTextField: View {
    let iconName: String
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .imageScale(.medium)
                .fontWeight(.semibold)
                .foregroundStyle(Color.gray60)
            
            TextField(text, text: $text)
                .font(.callout)
                .foregroundStyle(Color.gray60)
                .autocorrectionDisabled()
            
            Spacer()
            
            Image(systemName: "pencil.line")
                .imageScale(.large)
                .fontWeight(.semibold)
                .foregroundStyle(Color.gray30)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(
            Capsule()
                .stroke(Color.gray30, lineWidth: 1)
                .fill(Color.white)
        )
        .padding(.horizontal)
    }
}

struct EditReceiptDatePicker: View {
    let iconName: String
    
    @Binding var date: Date
    @Binding var showDatePicker: Bool
    
    var body: some View {
        HStack {
            Text(date.toString("MMM d, yyyy"))
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
            
            Text("•")
            
            Text(date.toString("hh:mm a"))
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
            
            Spacer()
            
            Image(systemName: "calendar")
                .imageScale(.large)
                .fontWeight(.semibold)
                .foregroundStyle(Color.gray60)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(
            Capsule()
                .stroke(Color.gray30, lineWidth: 1)
                .fill(Color.white)
        )
        .onTapGesture {
            showDatePicker.toggle()
        }
        .sheet(isPresented: $showDatePicker) {
            SheetDatePicker(date: $date)
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.visible)
        }
        .padding(.horizontal)
    }
}

struct SheetDatePicker: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var date: Date
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Set Date")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.gray80)
                
                Spacer()
                
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.gray60)
                    .onTapGesture {
                        dismiss()
                    }
            }
            
            DatePicker(
                "Test",
                selection: $date,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            
            HStack {
                Text("Time")
                    .font(.callout)
                    .fontWeight(.bold)
                
                Spacer()
                
                Capsule()
                    .stroke(Color.gray30, lineWidth: 1)
                    .frame(width: 108, height: 32)
                    .overlay {
                        HStack(spacing: 8) {
                            Text(date.toString("hh:mm a"))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.gray60)
                            
                            Image(systemName: "chevron.down")
                                .imageScale(.small)
                                .foregroundStyle(Color.gray60)
                        }
                    }
                    .overlay {
                        DatePicker("", selection: $date, displayedComponents: [.hourAndMinute])
                            .blendMode(.destinationOver)
                    }
            }
            
            HStack {
                Text("Set Date")
                
                Image(systemName: "checkmark")
            }
            .callToActionButton()
            .anyButton(.press) {
                
            }
        }
        .padding()
    }
}

private struct PreviewView: View {
    @State private var receipt: ReceiptData = .mock
    
    var body: some View {
        EditReceiptView(receipt: receipt)
    }
}

#Preview {
    PreviewView()
}
