//
//  ChatModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/21/25.
//

import Foundation
import IdentifiableByString

struct ChatModel: Identifiable, Codable, Hashable, StringIdentifiable {
    let id: String
    let userId: String
    let avatarId: String
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case avatarId = "avatar_id"
        case dateCreated = "date_created"
    }
    
    static func chatId(userId: String, avatarId: String) -> String {
        "\(userId)_\(avatarId)"
    }
    
    static func new(userId: String, avatarId: String) -> Self {
        ChatModel(
            id: chatId(userId: userId, avatarId: avatarId),
            userId: userId,
            avatarId: avatarId,
            dateCreated: .now
        )
    }
    
    static var mock: Self {
        ChatModel(
            id: "mock_chat",
            userId: UserAuthInfo.mock.uid,
            avatarId: UUID().uuidString,
            dateCreated: Date()
        )
    }
}
