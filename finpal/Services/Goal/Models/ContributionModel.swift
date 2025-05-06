//
//  ContributionModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import Foundation

struct ContributionModel: Identifiable, Codable {
    let id: Int
    let date: Date
    let amount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case amount
    }
    
    static var mocks: [Self] {
        let now = Date()
        return [
            ContributionModel(
                id: 1,
                date: now.addingTimeInterval(days: -40),
                amount: 10_000
            ),
            
            ContributionModel(
                id: 2,
                date: now.addingTimeInterval(days: 30),
                amount: 10_000
            ),
            
            ContributionModel(
                id: 3,
                date: now.addingTimeInterval(days: 60),
                amount: 7_000
            ),
            
            ContributionModel(
                id: 4,
                date: now,
                amount: 7_000
            )
        ]
    }
}
