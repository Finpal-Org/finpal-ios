//
//  LineItemModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import Foundation

struct LineItemModel: Identifiable, Codable, Equatable {
    let id: Int
    var quantity: Int
    var description: String
    var total: Double
    
    init(id: Int, quantity: Int, description: String, total: Double) {
        self.id = id
        self.quantity = quantity
        self.description = description
        self.total = total
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case quantity
        case description
        case total
    }
    
    static var mock: Self {
        mocks[0]
    }
    
    static var mocks: [Self] {
        return [
            LineItemModel(
                id: 1,
                quantity: 1,
                description: "Capuccino",
                total: 5.40
            ),
            
            LineItemModel(
                id: 2,
                quantity: 1,
                description: "Chocolate Donut",
                total: 8.13
            ),
            
            LineItemModel(
                id: 3,
                quantity: 2,
                description: "Caesar Salad",
                total: 23.38
            ),
            
            LineItemModel(
                id: 4,
                quantity: 1,
                description: "Iced Tea",
                total: 4.60
            ),
        ]
    }
    
    static func ==(lhs: LineItemModel, rhs: LineItemModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.quantity == rhs.quantity &&
               lhs.description == rhs.description &&
               lhs.total == rhs.total
    }
}
