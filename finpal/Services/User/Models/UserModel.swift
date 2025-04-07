//
//  UserModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/10/25.
//

import SwiftUI

struct UserModel: Codable {
    let userId: String
    let email: String?
    let fullName: String?
    let monthlyIncome: Int?
    let savingsPercentage: Int?
    let creationDate: Date?
    let didCompleteOnboarding: Bool?
    let didVisitChatbotScreen: Bool?
    
    init(
        userId: String,
        email: String? = nil,
        fullName: String? = nil,
        monthlyIncome: Int? = nil,
        savingsPercentage: Int? = nil,
        creationDate: Date? = nil,
        didCompleteOnboarding: Bool? = nil,
        didVisitChatbotScreen: Bool? = nil
    ) {
        self.userId = userId
        self.email = email
        self.fullName = fullName
        self.monthlyIncome = monthlyIncome
        self.savingsPercentage = savingsPercentage
        self.creationDate = creationDate
        self.didCompleteOnboarding = didCompleteOnboarding
        self.didVisitChatbotScreen = didVisitChatbotScreen
    }
    
    init(auth: UserAuthInfo) {
        self.init(
            userId: auth.uid,
            email: auth.email,
            fullName: auth.fullName,
            monthlyIncome: auth.monthlyIncome,
            savingsPercentage: auth.savingsPercentage,
            creationDate: auth.creationDate
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case fullName = "full_name"
        case monthlyIncome = "monthly_income"
        case savingsPercentage = "savings_percentage"
        case creationDate = "creation_date"
        case didCompleteOnboarding = "did_complete_onboarding"
        case didVisitChatbotScreen = "did_visit_chatbot_screen"
    }
    
    static var mock: Self {
        UserModel(
            userId: "user1",
            email: "test@gmail.com",
            fullName: "John Doe",
            monthlyIncome: 5_000,
            savingsPercentage: 25,
            creationDate: Date(),
            didCompleteOnboarding: true,
            didVisitChatbotScreen: false
        )
    }
}
