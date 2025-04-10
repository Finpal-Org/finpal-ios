//
//  UserAuthInfo+Firebase.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/8/25.
//

import FirebaseAuth

extension UserAuthInfo {
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.creationDate = user.metadata.creationDate
    }
}
