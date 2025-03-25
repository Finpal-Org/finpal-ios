//
//  ReceiptService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import Foundation

protocol ReceiptService: Sendable {
    func createNewReceipt(receipt: ReceiptModel) async throws
}
