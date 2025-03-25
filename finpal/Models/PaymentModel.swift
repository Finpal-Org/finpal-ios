//
//  PaymentModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/18/25.
//

import SwiftUI

enum PaymentType: String, CaseIterable {
    case mastercard = "Mastercard"
    case visa = "Visa"
    case mada = "Mada"
    case applepay = "Apple Pay"
    case stcpay = "STC Pay"
    case cash = "Cash"
    
    var iconName: Image {
        switch self {
        case .mastercard:
            return Image(.mastercardLogo)
        case .visa:
            return Image(.visaLogo)
        case .mada:
            return Image(.madaLogo)
        case .applepay:
            return Image(.applepayLogo)
        case .stcpay:
            return Image(.stcpayLogo)
        case .cash:
            return Image(systemName: "banknote")
        }
    }
    
    static func stringToPaymentType(from string: String) -> PaymentType? {
        switch string {
        case "master_card":
            return .mastercard
        case "visa":
            return .visa
        case "mada":
            return .mada
        case "applepay":
            return .applepay
        case "cash":
            return .cash
        case "stcpay":
            return .stcpay
        default:
            return nil
        }
    }
    
    static func paymentTypeToString(from paymentType: PaymentType) -> String? {
        switch paymentType {
        case .mastercard:
            return "master_card"
        case .visa:
            return "visa"
        case .mada:
            return "mada"
        case .applepay:
            return "applepay"
        case .stcpay:
            return "stcpay"
        case .cash:
            return "cash"
        }
    }
}

struct PaymentModel: Codable {
    let displayName: String?
    let type: String?
    
    init(
        displayName: String? = nil,
        type: String? = nil
    ) {
        self.displayName = displayName
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case type
    }
    
    static var mock: Self {
        PaymentModel(displayName: "Mada", type: "mada")
    }
}
