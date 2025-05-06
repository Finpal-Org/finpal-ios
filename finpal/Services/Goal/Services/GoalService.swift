//
//  GoalService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI

protocol GoalService: Sendable {
    func createNewGoal(goal: GoalModel) async throws
    func getAllGoals(userId: String) async throws -> [GoalModel]
}
