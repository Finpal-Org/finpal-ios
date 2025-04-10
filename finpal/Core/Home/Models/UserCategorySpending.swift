//
//  UserCategorySpending.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/10/25.
//

import Foundation

struct UserCategorySpending: Identifiable, Hashable {
    var id = UUID()
    var category: CategoryModel
    var amount: Double
    
    static var mocks: [Self] {
        [
            UserCategorySpending(
                category: .entertainment,
                amount: 200
            ),
            
            UserCategorySpending(
                category: .fuel,
                amount: 150
            ),
            
            UserCategorySpending(
                category: .healthcare,
                amount: 100
            ),
            
            UserCategorySpending(
                category: .meal,
                amount: 30
            ),
            
            UserCategorySpending(
                category: .subscriptions,
                amount: 20
            ),
        ]
    }
}
