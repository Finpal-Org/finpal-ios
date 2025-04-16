//
//  ReceiptService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import SwiftUI

protocol ReceiptService: Sendable {
    func createNewReceipt(receipt: ReceiptModel, vendorName: String, vendorLogo: UIImage) async throws
    func getReceipt(id: String) async throws -> ReceiptModel
    func getReceiptsForCategory(category: CategoryModel) async throws -> [ReceiptModel]
    func getReceiptsForAuthor(userId: String) async throws -> [ReceiptModel]
    func removeAuthorIdFromReceipt(receiptId: String) async throws
    func removeAuthorIdFromAllUserReceipts(userId: String) async throws
}
