//
//  ReceiptModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import Foundation
import IdentifiableByString

struct ReceiptModel: Codable, StringIdentifiable {
    var id: String {
        receiptId
    }
    
    let receiptId: String
    let category: String?
    let date: String?
    let invoiceNumber: String?
    let isDuplicate: Bool?
    let lineItems: [LineItemModel]?
    let payment: PaymentModel?
    let subtotal: Double?
    let tax: Double?
    let total: Double?
    private(set) var vendor: VendorModel?
    let authorId: String?
    let note: String?
    
    init(
        receiptId: String,
        category: String? = nil,
        date: String? = nil,
        invoiceNumber: String? = nil,
        isDuplicate: Bool? = nil,
        lineItems: [LineItemModel]? = nil,
        payment: PaymentModel? = nil,
        subtotal: Double? = nil,
        tax: Double? = nil,
        total: Double? = nil,
        vendor: VendorModel? = nil,
        authorId: String? = nil,
        note: String? = nil
    ) {
        self.receiptId = receiptId
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
        self.authorId = authorId
        self.note = note
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.receiptId = UUID().uuidString
        self.category = try values.decode(String.self, forKey: .category)
        self.date = try values.decode(String.self, forKey: .date)
        self.invoiceNumber = try values.decode(String.self, forKey: .invoiceNumber)
        self.isDuplicate = try values.decode(Bool.self, forKey: .isDuplicate)
        self.lineItems = try values.decode([LineItemModel].self, forKey: .lineItems)
        self.payment = try values.decode(PaymentModel.self, forKey: .payment)
        self.subtotal = try values.decode(Double.self, forKey: .subtotal)
        self.tax = try values.decode(Double.self, forKey: .tax)
        self.total = try values.decode(Double.self, forKey: .total)
        self.vendor = try values.decode(VendorModel.self, forKey: .vendor)
        self.authorId = nil
        self.note = nil
    }
    
    mutating func updateVendor(_ vendor: VendorModel) {
        self.vendor = vendor
    }
    
    enum CodingKeys: String, CodingKey {
        case receiptId = "receipt_id"
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
        case authorId = "author_id"
        case note = "note"
    }
    
    var categoryEnum: CategoryModel {
        CategoryModel(rawValue: category ?? "") ?? .meal
    }
    
    var dateText: String {
        if let date = DateFormatterUtility.shared.date(from: date ?? "", format: .standard) {
            let readableDate = DateFormatterUtility.shared.string(from: date, format: .mediumDate)
            let readableTime = DateFormatterUtility.shared.string(from: date, format: .timeOnly)
            return "\(readableDate) • \(readableTime)"
        }
        
        return "N/A"
    }
    
    static var mock: Self {
        mocks[0]
    }
    
    static var mocks: [Self] {
        [
            ReceiptModel(
                receiptId: "mock_receipt_1",
                category: "Meal",
                date: DateFormatterUtility.shared.string(from: .now, format: .standard),
                invoiceNumber: "123",
                isDuplicate: false,
                lineItems: LineItemModel.mocks,
                payment: PaymentModel.mock,
                subtotal: 32.67,
                tax: 4.32,
                total: 36.99,
                vendor: VendorModel.mock,
                authorId: UUID().uuidString
            ),
            
            ReceiptModel(
                receiptId: "mock_receipt_2",
                category: "Transportation",
                date: DateFormatterUtility.shared.string(from: .now, format: .standard),
                invoiceNumber: "456",
                isDuplicate: false,
                lineItems: LineItemModel.mocks,
                payment: PaymentModel.mock,
                subtotal: 46.32,
                tax: 5.98,
                total: 52.3,
                vendor: VendorModel.mock,
                authorId: UUID().uuidString
            ),
            
            ReceiptModel(
                receiptId: "mock_receipt_3",
                category: "Hotel",
                date: DateFormatterUtility.shared.string(from: .now, format: .standard),
                invoiceNumber: "789",
                isDuplicate: false,
                lineItems: LineItemModel.mocks,
                payment: PaymentModel.mock,
                subtotal: 41.51,
                tax: 3.10,
                total: 44.61,
                vendor: .mock,
                authorId: UUID().uuidString
            )
        ]
    }
    
}
