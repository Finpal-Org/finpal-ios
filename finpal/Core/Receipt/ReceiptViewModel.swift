//
//  ReceiptViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/19/25.
//

import SwiftUI

@Observable class ReceiptViewModel {
    var category: CategoryModel
    var date: Date
    var invoiceNumber: String
    var subtotal: Float
    var tax: Float
    var total: Float
    
    var imageURL: String?
    var receiptImage: UIImage?
    
    var lineItems: [LineItemModel]
    
    var vendorName: String
    var vendorLogo: String?
    var vendorImage: UIImage?
    
    var paymentName: String?
    var paymentType: PaymentType?
    
    init(scannedReceipt: ScannedReceiptModel) {
        self.category = scannedReceipt.categoryEnum
        
        if let dateString = scannedReceipt.date, let formattedDate = DateFormatterUtility.shared.date(from: dateString, format: .standard) {
            self.date = formattedDate
        } else {
            self.date = .now
        }
        
        if let imageUrl = scannedReceipt.imgUrl {
            self.imageURL = imageUrl
        } else {
            self.imageURL = nil
        }
        
        self.invoiceNumber = scannedReceipt.invoiceNumber ?? "Not Found"
        self.subtotal = scannedReceipt.subtotal ?? 0.0
        self.tax = scannedReceipt.tax ?? 0.0
        self.total = scannedReceipt.total ?? 0.0
        
        self.lineItems = scannedReceipt.lineItems ?? []
        
        if let vendor = scannedReceipt.vendor {
            self.vendorName = vendor.name ?? ""
            self.vendorLogo = vendor.logoURL ?? nil
        } else {
            self.vendorName = ""
            self.vendorLogo = nil
        }
        
        if let payment = scannedReceipt.payment {
            self.paymentName = payment.displayName
            self.paymentType = payment.paymentTypeEnum
        } else {
            self.paymentName = PaymentType.mada.rawValue
            self.paymentType = PaymentType.mada
        }
    }
    
    var dateText: String {
        let readableDate = DateFormatterUtility.shared.string(from: date, format: .mediumDate)
        let readableTime = DateFormatterUtility.shared.string(from: date, format: .timeOnly)
        return "\(readableDate) • \(readableTime)"
    }
    
    @MainActor
    func loadImageFromURL() async throws {
        guard let urlString = imageURL else {
            throw URLError(.badURL)
        }
        
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
        
        self.receiptImage = image
    }
    
    @MainActor
    func loadVendorImageFromURL(from urlString: String) async throws {
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
