//
//  MockReceiptService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import SwiftUI

struct MockReceiptService: ReceiptService {
    let receipts: [ReceiptModel]
    let delay: Double
    let showError: Bool
    
    init(receipts: [ReceiptModel] = ReceiptModel.mocks, delay: Double = 0, showError: Bool = false) {
        self.receipts = receipts
        self.delay = delay
        self.showError = showError
    }
    
    private func tryShowError() throws {
        if showError {
            throw URLError(.unknown)
        }
    }
    
    func createNewReceipt(receipt: ReceiptModel, receiptImage: UIImage?, vendorName: String, vendorLogo: UIImage) async throws {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
    }
    
    func getReceipt(id: String) async throws -> ReceiptModel {
        try await Task.sleep(for: .seconds(delay))
        
        try tryShowError()
        guard let receipt = receipts.first(where: { $0.id == id }) else {
            throw URLError(.noPermissionsToReadFile)
        }
        
        return receipt
    }
    
    func getReceiptsForCategory(category: CategoryModel) async throws -> [ReceiptModel] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return receipts.shuffled()
    }
    
    func getReceiptsForAuthor(userId: String) async throws -> [ReceiptModel] {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        return receipts.shuffled()
    }
    
    func removeAuthorIdFromReceipt(receiptId: String) async throws {
        
    }
    
    func removeAuthorIdFromAllUserReceipts(userId: String) async throws {
        
    }
}
