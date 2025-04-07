//
//  UserAuthInfo.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/7/25.
//

import SwiftUI

struct UserAuthInfo: Sendable, Codable {
    let uid: String
    let email: String?
    let fullName: String?
    let monthlyIncome: Int?
    let savingsPercentage: Int?
    let creationDate: Date?
    let lastSignInDate: Date?
    
    init(
        uid: String,
        email: String? = nil,
        fullName: String? = nil,
        monthlyIncome: Int? = nil,
        savingsPercentage: Int? = nil,
        creationDate: Date? = nil,
        lastSignInDate: Date? = nil
    ) {
        self.uid = uid
        self.email = email
        self.fullName = fullName
        self.monthlyIncome = monthlyIncome
        self.savingsPercentage = savingsPercentage
        self.creationDate = creationDate
        self.lastSignInDate = lastSignInDate
    }
    
    enum CodingKeys: String, CodingKey {
        case uid
        case email
        case fullName = "full_name"
        case monthlyIncome = "monthly_income"
        case savingsPercentage = "savings_percentage"
        case creationDate = "creation_date"
        case lastSignInDate = "last_sign_in_date"
    }
    
    static var mock: Self {
        UserAuthInfo(
            uid: "mock_user_123",
            email: "hello@world.com",
            fullName: "John Doe",
            monthlyIncome: 9_000,
            savingsPercentage: 25,
            creationDate: .now,
            lastSignInDate: .now
        )
    }
}
