//
//  UserAuthInfo+Firebase.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/7/25.
//

import FirebaseAuth

extension UserAuthInfo {
    
    init(user: User, fullName: String? = nil, monthlyIncome: Int? = nil, savingsPercentage: Int? = nil) {
        self.uid = user.uid
        self.email = user.email
        self.fullName = fullName
        self.monthlyIncome = monthlyIncome
        self.savingsPercentage = savingsPercentage
        self.creationDate = user.metadata.creationDate
        self.lastSignInDate = user.metadata.lastSignInDate
    }
}
