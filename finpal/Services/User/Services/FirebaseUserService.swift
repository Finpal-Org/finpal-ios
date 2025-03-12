//
//  FirebaseUserService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import FirebaseFirestore

struct FirebaseUserService: UserService {
    
    private var collection: CollectionReference {
        Firestore.firestore().collection("users")
    }
    
    func saveUser(user: UserModel) async throws {
        try collection.document(user.userId).setData(from: user, merge: true)
    }
    
    func markOnboardingCompleted(userId: String) async throws {
        try await collection.document(userId).updateData([
            UserModel.CodingKeys.didCompleteOnboarding.rawValue: true
        ])
    }
    
    // TODO: Get current user
    
    func deleteUser(userId: String) async throws {
        try await collection.document(userId).delete()
    }
}
