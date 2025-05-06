//
//  FirebaseGoalService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import FirebaseFirestore
import SwiftfulFirestore

struct FirebaseGoalService: GoalService {
    
    private var collection: CollectionReference {
        Firestore.firestore().collection("goals")
    }
    
    func createNewGoal(goal: GoalModel) async throws {
        try collection.document(goal.id).setData(from: goal, merge: true)
    }
    
    func getAllGoals(userId: String) async throws -> [GoalModel] {
        try await collection
            .whereField(GoalModel.CodingKeys.userId.rawValue, isEqualTo: userId)
            .getAllDocuments()
    }
}
