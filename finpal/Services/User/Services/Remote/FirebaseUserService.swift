//
//  FirebaseUserService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import FirebaseFirestore
import SwiftfulFirestore
import FirebaseStorage

typealias ListenerRegistration = FirebaseFirestore.ListenerRegistration

struct AnyListener: @unchecked Sendable {
    let listener: ListenerRegistration
}

struct FirebaseUserService: RemoteUserService {
    
    private var collection: CollectionReference {
        Firestore.firestore().collection("users")
    }
    
    private var storageRef: StorageReference {
        Storage.storage().reference()
    }
    
    func saveUser(auth: UserAuthInfo, fullName: String, monthlyIncome: Int, savingsPercentage: Int, image: UIImage?) async throws {
        var url: URL?
        
        if let image {
            let photoName = UUID().uuidString
            let path = "users/\(auth.uid)/\(photoName)"
            
            url = try await FirebaseImageUploadService().uploadImage(image: image, path: path)
        }
        
        let user = UserModel(
            userId: auth.uid,
            email: auth.email,
            fullName: fullName,
            monthlyIncome: monthlyIncome,
            savingsPercentage: savingsPercentage,
            creationDate: auth.creationDate,
            didCompleteOnboarding: true,
            didVisitChatbotScreen: false,
            profileImageURL: url?.absoluteString ?? nil
        )
        
        try collection.document(user.userId).setData(from: user, merge: true)
    }
    
    func markOnboardingCompleted(userId: String) async throws {
        try await collection.document(userId).updateData([
            UserModel.CodingKeys.didCompleteOnboarding.rawValue: true
        ])
    }
    
    func markChatbotScreenVisited(userId: String) async throws {
        try await collection.document(userId).updateData([
            UserModel.CodingKeys.didVisitChatbotScreen.rawValue: true
        ])
    }
    
    func streamUser(userId: String, onListenerConfigured: @escaping (ListenerRegistration) -> Void) -> AsyncThrowingStream<UserModel, Error> {
        collection.streamDocument(id: userId, onListenerConfigured: onListenerConfigured)
    }
    
    func deleteUser(userId: String) async throws {
        print("[DEBUG] deleteUser \(userId) started")
        
        let storageRef = storageRef.child("users/\(userId)")
        let result = try await storageRef.listAll()
        
        for item in result.items {
            print("[DEBUG] item: \(item.name)")
            try await item.delete()
            print("[DEBUG] item: \(item.name) deleted")
        }
        
        try await collection.document(userId).delete()
        print("[DEBUG] Firestore deleteUser \(userId) completed")
    }
    
    func fetchCurrentUser(auth: UserAuthInfo) async throws -> UserModel {
        let snapshot = try await collection.document(auth.uid).getDocument()
        let user = try snapshot.data(as: UserModel.self)
        return user
    }
}
