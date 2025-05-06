//
//  GoalModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import Foundation
import IdentifiableByString

struct GoalModel: Identifiable, Codable, StringIdentifiable {
    let id: String
    let userId: String
    let name: String
    let iconName: String
    let total: Int
    let difficulty: Int
    let deadline: Date
    let monthlyContribution: Int
    let contributions: [ContributionModel]
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case iconName = "icon_name"
        case total
        case difficulty
        case deadline
        case monthlyContribution = "monthly_contribution"
        case contributions
    }
    
    static func newGoal(name: String, iconName: String, total: Int, difficulty: Int, deadline: Date, monthlyContribution: Int, userId: String) -> Self {
        GoalModel(
            id: UUID().uuidString,
            userId: userId,
            name: name,
            iconName: iconName,
            total: total,
            difficulty: difficulty,
            deadline: deadline,
            monthlyContribution: monthlyContribution,
            contributions: []
        )
    }
    
    static var mock: Self {
        mocks[0]
    }
    
    static var mocks: [Self] {
        let now = Date()
        return [
            GoalModel(
                id: UUID().uuidString,
                userId: UserModel.mock.userId,
                name: "Buy A Car",
                iconName: "car",
                total: 200_000,
                difficulty: 80,
                deadline: now.addingTimeInterval(days: 400),
                monthlyContribution: 20_000,
                contributions: ContributionModel.mocks
            ),
            
            GoalModel(
                id: UUID().uuidString,
                userId: UserModel.mock.userId,
                name: "Trip to Japan",
                iconName: "airplane",
                total: 15_000,
                difficulty: 50,
                deadline: now.addingTimeInterval(days: 80),
                monthlyContribution: 2_500,
                contributions: ContributionModel.mocks
            ),
            
            GoalModel(
                id: UUID().uuidString,
                userId: UserModel.mock.userId,
                name: "Emergency Fund",
                iconName: "archivebox",
                total: 10_000,
                difficulty: 60,
                deadline: now.addingTimeInterval(days: 100),
                monthlyContribution: 834,
                contributions: ContributionModel.mocks
            ),
            
            GoalModel(
                id: UUID().uuidString,
                userId: UserModel.mock.userId,
                name: "New Laptop",
                iconName: "printer",
                total: 8_000,
                difficulty: 30,
                deadline: now.addingTimeInterval(days: 250),
                monthlyContribution: 2_000,
                contributions: ContributionModel.mocks
            ),
        ]
    }
}
