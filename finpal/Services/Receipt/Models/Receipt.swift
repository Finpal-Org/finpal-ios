//
//  Receipt.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import Foundation

enum Category: String, CaseIterable, Identifiable {
    case transport = "Transport"
    case grocery = "Grocery"
    case rent = "Rent"
    case health = "Health"
    case shopping = "Shopping"
    case utility = "Utility"
    case bill = "Bill"
    case personal = "Personal"
    case gift = "Gift"
    case charity = "Charity"
    case meal = "Meal"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .transport:
            return "car.side"
        case .grocery:
            return "handbag"
        case .rent:
            return "house"
        case .health:
            return "cross"
        case .shopping:
            return "cart"
        case .utility:
            return "lightbulb"
        case .bill:
            return "banknote"
        case .personal:
            return "person"
        case .gift:
            return "gift"
        case .charity:
            return "heart"
        case .meal:
            return "fork.knife"
        case .other:
            return "plus"
        }
    }
}

struct Receipt: Codable {
    let packageID: String
    let documentType: String
    let data: ReceiptData
    
    enum CodingKeys: String, CodingKey {
        case packageID = "package_id"
        case documentType = "document_type"
        case data
    }
}

struct ReceiptData: Identifiable, Codable {
    let id: Int
    let category: String
    let currencyCode: String
    var dateString: String
    let documentType: String
    let imageURL: String
    let invoiceNumber: String
    let lineItems: [LineItem]
    let subtotal: Double
    let tax: Double
    let total: Double
    var vendor: Vendor

    enum CodingKeys: String, CodingKey {
        case id
        case category
        case currencyCode = "currency_code"
        case dateString = "date"
        case documentType = "document_type"
        case imageURL = "img_url"
        case invoiceNumber = "invoice_number"
        case lineItems = "line_items"
        case subtotal
        case tax
        case total
        case vendor
    }
    
    var dateToString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            return "\(formattedDate(date: date)) • \(formattedTime(date: date))"
        } else {
            return "N/A"
        }
    }
    
    var date: Date {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.date(from: dateString) ?? Date()
        }
        set {
            dateString = newValue.description
        }
    }
    
    var subtotalString: String {
        "\(currencyCode) \(String(format: "%.2f", subtotal))"
    }
    
    var taxString: String {
        "\(currencyCode) \(String(format: "%.2f", tax))"
    }
    
    var totalString: String {
        "\(currencyCode) \(String(format: "%.2f", total))"
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func formattedTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
    
    static var mock: Self {
        ReceiptData(
            id: 1,
            category: "Meals & Entertainment",
            currencyCode: "SAR",
            dateString: "2025-02-06 07:40:03",
            documentType: "receipt",
            imageURL: Constants.randomImageURL,
            invoiceNumber: "274565",
            lineItems: LineItem.mocks,
            subtotal: 43.48,
            tax: 6.52,
            total: 50.0,
            vendor: .mock
        )
    }
}
