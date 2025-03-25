//
//  ReceiptModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import Foundation

struct ReceiptModel: Identifiable, Codable {
    let id: Int
    let category: String?
    let date: String?
    let invoiceNumber: String?
    let isDuplicate: Bool?
    let lineItems: [LineItemModel]?
    let payment: PaymentModel?
    let subtotal: Double?
    let tax: Double?
    let total: Double?
    let vendor: VendorModel?
    
    init(
        id: Int,
        category: String? = nil,
        date: String? = nil,
        invoiceNumber: String? = nil,
        isDuplicate: Bool? = nil,
        lineItems: [LineItemModel]? = nil,
        payment: PaymentModel? = nil,
        subtotal: Double? = nil,
        tax: Double? = nil,
        total: Double? = nil,
        vendor: VendorModel? = nil
    ) {
        self.id = id
        self.category = category
        self.date = date
        self.invoiceNumber = invoiceNumber
        self.isDuplicate = isDuplicate
        self.lineItems = lineItems
        self.payment = payment
        self.subtotal = subtotal
        self.tax = tax
        self.total = total
        self.vendor = vendor
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case category
        case date
        case invoiceNumber = "invoice_number"
        case isDuplicate = "is_duplicate"
        case lineItems = "line_items"
        case payment
        case subtotal
        case tax
        case total
        case vendor
    }
    
    var stringToDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date {
            return formatter.date(from: date)
        }
        
        return nil
    }
    
    var formattedDate: String {
        guard let date = stringToDate else {
            return "N/A"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateString = dateFormatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        let timeString = timeFormatter.string(from: date)
        
        return "\(dateString) • \(timeString)"
    }
    
    static var mock: Self {
        ReceiptModel(
            id: 1,
            category: "Meal",
            date: Date.now.description,
            invoiceNumber: "123",
            isDuplicate: false,
            lineItems: LineItemModel.mocks,
            payment: PaymentModel.mock,
            subtotal: 41.51,
            tax: 3.10,
            total: 44.61,
            vendor: .mock
        )
    }
}
