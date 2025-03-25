//
//  ScannedReceiptViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/19/25.
//

import SwiftUI

class ScannedReceiptViewModel: ObservableObject {
    @Published var receiptId: String
    @Published var vendorName: String?
    @Published var vendorImage: String = ""
    @Published var date: Date = .now
    @Published var invoiceNumber: String?
    @Published var lineItems: [LineItemModel] = []
    @Published var subtotal: Double = 0.0
    @Published var tax: Double = 0.0
    @Published var total: Double = 0.0
    
    // Category
    @Published var detectedCategoryString: String
    @Published var category: CategoryModel?
    
    @Published var paymentType: PaymentType?
    @Published var vendorLogo: UIImage?
    
    init(receipt: ReceiptModel) {
        self.receiptId = "\(receipt.id)"
        self.vendorName = receipt.vendor?.name ?? "N/A"
        self.vendorImage = receipt.vendor?.logoURL ?? ""
        self.date = receipt.stringToDate ?? .now
        self.invoiceNumber = receipt.invoiceNumber ?? "N/A"
        self.lineItems = receipt.lineItems ?? []
        self.subtotal = receipt.subtotal ?? 0.0
        self.tax = receipt.tax ?? 0.0
        self.total = receipt.total ?? 0.0
        
        self.detectedCategoryString = receipt.category ?? CategoryModel.meal.rawValue
        self.category = CategoryModel(rawValue: detectedCategoryString)
        
        self.paymentType = PaymentType.stringToPaymentType(from: receipt.payment?.type ?? "none")
        self.vendorLogo = urlToImage(receipt.vendor?.logoURL ?? "")
    }
    
    private func urlToImage(_ imageURL: String) -> UIImage? {
        guard let url = URL(string: imageURL) else { return nil }
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        guard let imageToSave = UIImage(data: imageData) else { return nil }
        
        return imageToSave
    }
    
    func updateImage(imageUrlString: String) {
        guard let url = URL(string: imageUrlString) else { return }
        
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.vendorLogo = image
                }
            } else {
                DispatchQueue.main.async {
                    self.vendorLogo = UIImage(systemName: "exclamationmark.triangle")
                }
            }
        }
    }
    
    func getPayment() -> PaymentModel {
        let displayName = paymentType?.rawValue
        let type = PaymentType.paymentTypeToString(from: paymentType ?? .mastercard)
        return PaymentModel(displayName: displayName, type: type)
    }
    
}
