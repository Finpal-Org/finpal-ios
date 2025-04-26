//
//  ExportDataViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/24/25.
//

import SwiftUI
import Observation

@Observable class ExportDataViewModel {
    var fromDate: Date = .now.addingTimeInterval(days: -7)
    var toDate: Date = .now
    
    var showingExporter = false
    var csvFile: CSVFile?
    
    var showPopup = false
    var errorMessage = ""
    
    var fromDateText: String {
        DateFormatterUtility.shared.string(from: fromDate, format: .mediumDate)
    }
    
    var toDateText: String {
        DateFormatterUtility.shared.string(from: toDate, format: .mediumDate)
    }
    
    func exportData(receipts: [ReceiptModel]) {
        let filteredReceipts = receiptsInDateRange(from: fromDate, to: toDate, receipts: receipts)
        
        if filteredReceipts.isEmpty {
            errorMessage = "No receipts found for the selected dates."
            showPopup = true
            return
        }
        
        csvFile = CSVFile(receipts: filteredReceipts)
        showingExporter = true
    }
    
    func showError(_ message: String) {
        errorMessage = message
        showPopup = true
    }
    
    private func receiptsInDateRange(from fromDate: Date, to toDate: Date, receipts: [ReceiptModel]) -> [ReceiptModel] {
        return receipts.filter { receipt in
            return receipt.date >= fromDate && receipt.date <= toDate
        }
    }
}
