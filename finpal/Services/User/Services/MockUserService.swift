//
//  MockUserService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import Foundation

struct MockUserService: UserService {
    let currentUser: UserModel?
    
    init(user: UserModel? = nil) {
        self.currentUser = user
    }
    
    func saveUser(user: UserModel) async throws {
        
    }
    
    func markOnboardingCompleted(userId: String) async throws {
        
    }
    
    func deleteUser(userId: String) async throws {
        
    }
}
