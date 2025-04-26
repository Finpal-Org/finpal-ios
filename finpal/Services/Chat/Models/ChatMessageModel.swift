//
//  ChatMessageModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/21/25.
//

import Foundation
import IdentifiableByString

struct ChatMessageModel: Identifiable, Codable, StringIdentifiable {
    let id: String
    let chatId: String
    let authorId: String?
    let content: AIChatModel?
    let dateCreated: Date?
    
    var dateCreatedCalculated: Date {
        dateCreated ?? .distantPast
    }
    
    init(
        id: String,
        chatId: String,
        authorId: String? = nil,
        content: AIChatModel? = nil,
        dateCreated: Date? = nil
    ) {
        self.id = id
        self.chatId = chatId
        self.authorId = authorId
        self.content = content
        self.dateCreated = dateCreated
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case authorId = "author_id"
        case content
        case dateCreated = "date_created"
    }
    
    static func newUserMessage(chatId: String, userId: String, message: AIChatModel) -> Self {
        ChatMessageModel(
            id: UUID().uuidString,
            chatId: chatId,
            authorId: userId,
            content: message,
            dateCreated: .now
        )
    }
    
    static func newAIMessage(chatId: String, avatarId: String, message: AIChatModel) -> Self {
        ChatMessageModel(
            id: UUID().uuidString,
            chatId: chatId,
            authorId: avatarId,
            content: message,
            dateCreated: .now
        )
    }
    
    static var mock: ChatMessageModel {
        mocks[0]
    }
    
    static var mocks: [ChatMessageModel] {
        let now = Date()
        return [
            ChatMessageModel(
                id: "msg1",
                chatId: "1",
                authorId: UserAuthInfo.mock.uid,
                content: AIChatModel(role: .user, content: "Hello, how are you?"),
                dateCreated: now
            ),
            ChatMessageModel(
                id: "msg2",
                chatId: "2",
                authorId: UUID().uuidString,
                content: AIChatModel(role: .assistant, content: "I'm doing well, thanks for asking!"),
                dateCreated: now.addingTimeInterval(minutes: -5)
            ),
            ChatMessageModel(
                id: "msg3",
                chatId: "3",
                authorId: UserAuthInfo.mock.uid,
                content: AIChatModel(role: .user, content: "Anyone up for a game tonight?"),
                dateCreated: now.addingTimeInterval(hours: -1)
            ),
            ChatMessageModel(
                id: "msg4",
                chatId: "1",
                authorId: UUID().uuidString,
                content: AIChatModel(role: .assistant, content: "Sure, count me in!"),
                dateCreated: now.addingTimeInterval(hours: -2, minutes: -15)
            )
        ]
    }
}
