//
//  GoalsManager.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI
import Observation

@MainActor
@Observable class GoalsManager {
    private let service: GoalService
    
    init(service: GoalService) {
        self.service = service
    }
    
    func createNewGoal(goal: GoalModel) async throws {
        try await service.createNewGoal(goal: goal)
    }
    
    func getAllGoals(userId: String) async throws -> [GoalModel] {
        try await service.getAllGoals(userId: userId)
    }
}
