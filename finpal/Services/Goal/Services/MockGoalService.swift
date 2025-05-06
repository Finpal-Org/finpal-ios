//
//  MockGoalService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI

struct MockGoalService: GoalService {
    let goals: [GoalModel]
    
    init(goals: [GoalModel] = GoalModel.mocks) {
        self.goals = goals
    }
    
    func createNewGoal(goal: GoalModel) async throws {
        
    }
    
    func getAllGoals(userId: String) async throws -> [GoalModel] {
        try await Task.sleep(for: .seconds(2))
        return goals
    }
}
