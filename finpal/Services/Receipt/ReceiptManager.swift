//
//  ReceiptManager.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import SwiftUI

@MainActor
@Observable class ReceiptManager {
    private let service: ReceiptService
    
    init(service: ReceiptService) {
        self.service = service
    }
    
    func createNewReceipt(receipt: ReceiptModel, vendorName: String, vendorLogo: UIImage) async throws {
        try await service.createNewReceipt(receipt: receipt, vendorName: vendorName, vendorLogo: vendorLogo)
    }
    
    func getReceipt(id: String) async throws -> ReceiptModel {
        try await service.getReceipt(id: id)
    }
    
    func getReceiptsForCategory(category: CategoryModel) async throws -> [ReceiptModel] {
        try await service.getReceiptsForCategory(category: category)
    }
    
    func getReceiptsForAuthor(userId: String) async throws -> [ReceiptModel] {
        try await service.getReceiptsForAuthor(userId: userId)
    }
    
    func removeAuthorIdFromReceipt(receiptId: String) async throws {
        try await service.removeAuthorIdFromReceipt(receiptId: receiptId)
    }
    
    func removeAuthorIdFromAllUserReceipts(userId: String) async throws {
        try await service.removeAuthorIdFromAllUserReceipts(userId: userId)
    }
}
