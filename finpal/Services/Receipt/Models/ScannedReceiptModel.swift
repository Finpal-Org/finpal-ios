//
//  ScannedReceiptModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/21/25.
//

import Foundation

struct ScannedReceiptModel: Codable {
    let category: String?
    let date: String?
    let imgUrl: String?
    let invoiceNumber: String?
    let isDuplicate: Bool?
    let lineItems: [LineItemModel]?
    let payment: PaymentModel?
    let subtotal: Float?
    let tax: Float?
    let total: Float?
    let vendor: VendorModel?
    
    var categoryEnum: CategoryModel {
        CategoryModel(rawValue: category ?? "Meal") ?? .meal
    }
    
    init(
        category: String? = nil,
        date: String? = nil,
        imgUrl: String? = nil,
        invoiceNumber: String? = nil,
        isDuplicate: Bool? = nil,
        lineItems: [LineItemModel]? = nil,
        payment: PaymentModel? = nil,
        subtotal: Float? = nil,
        tax: Float? = nil,
        total: Float? = nil,
        vendor: VendorModel? = nil
    ) {
        self.category = category
        self.date = date
        self.imgUrl = imgUrl
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
        case category
        case date
        case imgUrl = "img_url"
        case invoiceNumber = "invoice_number"
        case isDuplicate = "is_duplicate"
        case lineItems = "line_items"
        case payment
        case subtotal
        case tax
        case total
        case vendor
    }
    
    static var mock: Self {
        ScannedReceiptModel(
            category: "Meal",
            date: "2025-03-30 07:10:22",
            imgUrl: Constants.randomImageURL,
            invoiceNumber: "123",
            isDuplicate: false,
            lineItems: LineItemModel.mocks,
            payment: PaymentModel.mock,
            subtotal: 41.51,
            tax: 3.10,
            total: 44.61,
            vendor: VendorModel.mock
        )
    }
}
