//
//  UserModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/10/25.
//

import Foundation
import SwiftUI

struct UserModel: Codable {
    let userId: String
    let email: String?
    let name: String?
    let creationDate: Date?
    let didCompleteOnboarding: Bool?
    private(set) var profileImageName: String?
    
    init(
        userId: String,
        email: String? = nil,
        name: String? = nil,
        creationDate: Date? = nil,
        didCompleteOnboarding: Bool? = nil,
        profileImageName: String? = nil
    ) {
        self.userId = userId
        self.email = email
        self.name = name
        self.creationDate = creationDate
        self.didCompleteOnboarding = didCompleteOnboarding
        self.profileImageName = profileImageName
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case name
        case creationDate = "creation_date"
        case didCompleteOnboarding = "did_complete_onboarding"
        case profileImageName = "profile_image_name"
    }
    
    mutating func updateProfileImage(imageName: String) {
        profileImageName = imageName
    }
    
    static var mock: Self {
        UserModel(
            userId: "user1",
            email: "example@gmail.com",
            name: "John Doe",
            creationDate: .now,
            didCompleteOnboarding: true,
            profileImageName: Constants.randomImageURL
        )
    }
}
