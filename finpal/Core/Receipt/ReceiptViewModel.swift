//
//  ReceiptViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/19/25.
//

import SwiftUI
import SDWebImageSwiftUI

@Observable class ReceiptViewModel {
    var category: CategoryModel?
    var date: Date?
    var invoiceNumber: String
    var subtotal: Double
    var tax: Double
    var total: Double
    
    var lineItems: [LineItemModel]
    
    var vendorName: String
    var vendorLogo: String?
    var vendorImage: UIImage?
    
    var paymentName: String?
    var paymentType: PaymentType?
    
    init(scannedReceipt: ReceiptModel) {
        self.category = scannedReceipt.categoryEnum
        self.date = DateFormatterUtility.shared.date(from: scannedReceipt.date ?? "", format: .standard)
        self.invoiceNumber = scannedReceipt.invoiceNumber ?? ""
        self.subtotal = scannedReceipt.subtotal ?? 0.0
        self.tax = scannedReceipt.tax ?? 0.0
        self.total = scannedReceipt.total ?? 0.0
        self.lineItems = scannedReceipt.lineItems ?? []
        
        if let vendor = scannedReceipt.vendor {
            self.vendorName = vendor.name ?? ""
            self.vendorLogo = vendor.logoURL ?? nil
        } else {
            self.vendorName = ""
            self.vendorLogo = Constants.randomImageURL
        }
        
        if let payment = scannedReceipt.payment {
            self.paymentName = payment.displayName
            self.paymentType = payment.paymentTypeEnum
        }
    }
    
    var dateText: String {
        let readableDate = DateFormatterUtility.shared.string(from: date ?? .now, format: .mediumDate)
        let readableTime = DateFormatterUtility.shared.string(from: date ?? .now, format: .timeOnly)
        return "\(readableDate) • \(readableTime)"
    }
    
    @MainActor
    func loadImageFromURL(from urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        self.vendorImage = image
    }
}
