//
//  ReceiptModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import Foundation
import IdentifiableByString

struct ReceiptModel: Identifiable, Codable, Hashable, StringIdentifiable {
    let id: String
    let userId: String
    let category: CategoryModel
    let date: Date
    let invoiceNumber: String
    let isDuplicate: Bool
    let lineItems: [LineItemModel]
    let payment: PaymentModel
    let subtotal: Float
    let tax: Float
    let total: Float
    let note: String
    
    private(set) var vendor: VendorModel?
    private(set) var imageName: String?
    
    init(
        id: String,
        userId: String,
        category: CategoryModel,
        date: Date,
        invoiceNumber: String,
        isDuplicate: Bool,
        lineItems: [LineItemModel],
        payment: PaymentModel,
        subtotal: Float,
        tax: Float,
        total: Float,
        note: String,
        vendor: VendorModel? = nil,
        imageName: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.category = category
        self.date = date
        self.invoiceNumber = invoiceNumber
        self.isDuplicate = isDuplicate
        self.lineItems = lineItems
        self.payment = payment
        self.subtotal = subtotal
        self.tax = tax
        self.total = total
        self.note = note
        self.vendor = vendor
        self.imageName = imageName
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.userId = try values.decode(String.self, forKey: .userId)
        self.category = try values.decode(CategoryModel.self, forKey: .category)
        self.date = try values.decode(Date.self, forKey: .date)
        self.invoiceNumber = try values.decode(String.self, forKey: .invoiceNumber)
        self.isDuplicate = try values.decode(Bool.self, forKey: .isDuplicate)
        self.lineItems = try values.decode([LineItemModel].self, forKey: .lineItems)
        self.payment = try values.decode(PaymentModel.self, forKey: .payment)
        self.subtotal = try values.decode(Float.self, forKey: .subtotal)
        self.tax = try values.decode(Float.self, forKey: .tax)
        self.total = try values.decode(Float.self, forKey: .total)
        self.vendor = try values.decode(VendorModel.self, forKey: .vendor)
        self.note = try values.decode(String.self, forKey: .note)
        self.imageName = try values.decode(String.self, forKey: .imageName)
    }
    
    var dateText: String {
        let readableDate = DateFormatterUtility.shared.string(from: date, format: .mediumDate)
        let readableTime = DateFormatterUtility.shared.string(from: date, format: .timeOnly)
        return "\(readableDate) • \(readableTime)"
    }
    
    mutating func updateVendor(vendor: VendorModel) {
        self.vendor = vendor
    }
    
    mutating func updateReceiptImage(imageName: String) {
        self.imageName = imageName
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "receipt_id"
        case userId = "user_id"
        case category
        case date
        case invoiceNumber = "invoice_number"
        case isDuplicate = "is_duplicate"
        case lineItems = "line_items"
        case payment
        case subtotal
        case tax
        case total
        case note
        case vendor
        case imageName = "receipt_image"
    }
    
    static var mock: Self {
        mocks[0]
    }
    
    static var mocks: [Self] {
        [
            ReceiptModel(
                id: "mock_receipt_1",
                userId: UUID().uuidString,
                category: .meal,
                date: .now.addingTimeInterval(days: -1),
                invoiceNumber: "123",
                isDuplicate: false,
                lineItems: LineItemModel.mocks,
                payment: PaymentModel.mock,
                subtotal: 41.51,
                tax: 3.10,
                total: 44.61,
                note: "Hello world...",
                vendor: VendorModel(name: "Starbucks", logoURL: Constants.randomImageURL),
                imageName: Constants.randomImageURL
            ),
            
            ReceiptModel(
                id: "mock_receipt_2",
                userId: UUID().uuidString,
                category: .communication,
                date: .now,
                invoiceNumber: "456",
                isDuplicate: false,
                lineItems: LineItemModel.mocks,
                payment: PaymentModel.mock,
                subtotal: 46.32,
                tax: 5.98,
                total: 52.3,
                note: "Hello world...",
                vendor: VendorModel(name: "Apple Store", logoURL: Constants.randomImageURL),
                imageName: Constants.randomImageURL
            ),
            
            ReceiptModel(
                id: "mock_receipt_3",
                userId: UUID().uuidString,
                category: .entertainment,
                date: .now.addingTimeInterval(days: -7),
                invoiceNumber: "789",
                isDuplicate: false,
                lineItems: LineItemModel.mocks,
                payment: PaymentModel.mock,
                subtotal: 84.95,
                tax: 3.10,
                total: 86.25,
                note: "Hello world...",
                vendor: VendorModel(name: "Costco Wholesale", logoURL: Constants.randomImageURL),
                imageName: Constants.randomImageURL
            ),
        ]
    }
}
