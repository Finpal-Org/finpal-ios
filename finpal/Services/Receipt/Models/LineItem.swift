//
//  LineItem.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import Foundation

struct LineItem: Identifiable, Codable {
    var id: Int
    var quantity: Int
    var description: String
    var total: Double

    enum CodingKeys: CodingKey {
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
            LineItem(id: 1, quantity: 1, description: "Capuccino", total: 5.40),
            
            LineItem(id: 2, quantity: 1, description: "Chocolate Donut", total: 8.13),
            
            LineItem(id: 3, quantity: 2, description: "Caesar Salad", total: 23.38),
            
            LineItem(id: 4, quantity: 1, description: "Iced Tea", total: 4.60)
        ]
    }
}
