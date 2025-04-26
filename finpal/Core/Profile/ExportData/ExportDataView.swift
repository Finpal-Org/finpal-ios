//
//  ExportDataView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/23/25.
//

import SwiftUI

struct ExportDataView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @Environment(ReceiptManager.self) private var receiptManager
    
    @State private var myReceipts: [ReceiptModel] = []
    @State private var isLoading = true
    
    @State private var viewModel = ExportDataViewModel()
    
    @State private var showFromDatePicker = false
    @State private var showToDatePicker = false
    
    var body: some View {
        VStack(spacing: 32) {
            navigationBar
            
            Spacer()
            
            imageView
            titleView
            datesView
            exportButton
            
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
        .errorPopup(showingPopup: $viewModel.showPopup, viewModel.errorMessage) {
            viewModel.showPopup = false
        }
        .task {
            await loadData()
        }
    }
    
    private func loadData() async {
        do {
            let uid = try authManager.getAuthId()
            myReceipts = try await receiptManager.getReceiptsForAuthor(userId: uid)
        } catch {
            viewModel.showError("Failed to load receipts. Please try again.")
        }
        
        isLoading = false
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
        }
        .padding(.vertical)
    }
    
    private var imageView: some View {
        Image(.finpalExportData)
            .resizable()
            .scaledToFit()
            .frame(height: 96)
    }
    
    private var titleView: some View {
        VStack(spacing: 12) {
            Text("Export Data")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Text("Here you can seamlessly export your data and use them in MS Excel or Google Sheets.")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
                .padding(.horizontal, 16)
        }
    }
    
    private var datesView: some View {
        VStack(spacing: 16) {
            fromDateView
            toDateView
            
            Divider()
            
            Text("\(myReceipts.count) Transactions Found")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.gray60)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white, in: .rect(cornerRadius: 24))
        .mediumShadow()
    }
    
    private var fromDateView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("From")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            HStack {
                Text(viewModel.fromDateText)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.gray60)
                
                Spacer()
                
                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.gray60)
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                Capsule()
                    .stroke(Color.gray30, lineWidth: 1)
                    .fill(Color.white)
            )
            .anyButton(.press) {
                onFromDatePickerPressed()
            }
            .sheet(isPresented: $showFromDatePicker) {
                SheetDatePicker(date: $viewModel.fromDate, showTime: false)
                    .presentationDetents([.fraction(0.8)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private var toDateView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("To")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            HStack {
                Text(viewModel.toDateText)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.gray60)
                
                Spacer()
                
                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.gray60)
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                Capsule()
                    .stroke(Color.gray30, lineWidth: 1)
                    .fill(Color.white)
            )
            .anyButton(.press) {
                onToDatePickerPressed()
            }
            .sheet(isPresented: $showToDatePicker) {
                SheetDatePicker(date: $viewModel.toDate, showTime: false)
                    .presentationDetents([.fraction(0.8)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private var exportButton: some View {
        Group {
            if isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                HStack {
                    Text("Export")
                    
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .callToActionButton()
        .anyButton(.press) {
            onExportButtonPressed()
        }
        .fileExporter(
            isPresented: $viewModel.showingExporter,
            item: viewModel.csvFile,
            contentTypes: [.commaSeparatedText],
            defaultFilename: "Receipts.csv",
            onCompletion: { result in
                switch result {
                case .success(let url):
                    print("[finpal - DEBUG] Saved to \(url)")
                case .failure(let error):
                    viewModel.showError(error.localizedDescription)
                }
            }
        )
    }
    
    private func onBackButtonPressed() {
        dismiss()
    }
    
    private func onFromDatePickerPressed() {
        showFromDatePicker.toggle()
    }
    
    private func onToDatePickerPressed() {
        showToDatePicker.toggle()
    }
    
    private func onExportButtonPressed() {
        if isLoading {
            return
        }
        
        viewModel.exportData(receipts: myReceipts)
    }
}

#Preview {
    ExportDataView()
        .previewEnvironment()
}
