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
    
    func createNewReceipt(receipt: ReceiptModel) async throws {
        try await service.createNewReceipt(receipt: receipt)
    }
}
