//
//  MockUserPersistence.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/6/25.
//

import Foundation

struct MockUserPersistence: LocalUserPersistence {
    let currentUser: UserModel?
    
    init(user: UserModel? = nil) {
        self.currentUser = user
    }
    
    func getCurrentUser() -> UserModel? {
        currentUser
    }
    
    func saveCurrentUser(user: UserModel?) throws {
        
    }
}
