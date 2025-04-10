//
//  UserAuthInfo.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/8/25.
//

import SwiftUI

struct UserAuthInfo: Sendable {
    let uid: String
    let email: String?
    let creationDate: Date?
    
    init(
        uid: String,
        email: String? = nil,
        creationDate: Date? = nil
    ) {
        self.uid = uid
        self.email = email
        self.creationDate = creationDate
    }
    
    static var mock: Self {
        UserAuthInfo(
            uid: "mock_user_123",
            email: "hello@world.com",
            creationDate: .now
        )
    }
}
