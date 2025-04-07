//
//  ProfileSetupViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/28/25.
//

import SwiftUI
import Observation

@MainActor
@Observable class ProfileSetupViewModel {
    let email: String
    let password: String
    
    var fullName: String = ""
    var monthlyIncome: Int = 0
    var savingsPercentage: Double = 0.0
    var profileImage: UIImage?
    
    init(
        email: String,
        password: String,
        fullName: String,
        monthlyIncome: Int,
        savingsPercentage: Double,
        profileImage: UIImage? = nil
    ) {
        self.email = email
        self.password = password
        self.fullName = fullName
        self.monthlyIncome = monthlyIncome
        self.savingsPercentage = savingsPercentage
        self.profileImage = profileImage
    }
    
    func incrementMonthlyIncome() {
        monthlyIncome += 50
    }
    
    func decrementMonthlyIncome() {
        if monthlyIncome > 50 {
            monthlyIncome -= 50
        }
    }
    
    static var mock: ProfileSetupViewModel {
        ProfileSetupViewModel(
            email: "test@example.com",
            password: "abc123",
            fullName: "John Doe",
            monthlyIncome: 10_000,
            savingsPercentage: 25.0
        )
    }
}
