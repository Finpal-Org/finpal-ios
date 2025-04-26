//
//  FirebaseChatService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/27/25.
//

import FirebaseFirestore
import SwiftfulFirestore

struct FirebaseChatService: ChatService {
    
    private var collection: CollectionReference {
        Firestore.firestore().collection("chats")
    }
    
    private func messagesCollection(chatId: String) -> CollectionReference {
        collection.document(chatId).collection("messages")
    }
    
    func createNewChat(chat: ChatModel) async throws {
        try collection.document(chat.id).setData(from: chat, merge: true)
    }
    
    func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
        try await collection.getDocument(id: ChatModel.chatId(userId: userId, avatarId: avatarId))
    }
    
    func addChatMessage(chatId: String, message: ChatMessageModel) async throws {
        // Add the message to chat sub-collection
        try messagesCollection(chatId: chatId).document(message.id).setData(from: message, merge: true)
    }
    
    func getLastChatMessage(chatId: String) async throws -> ChatMessageModel? {
        let messages: [ChatMessageModel] = try await messagesCollection(chatId: chatId)
            .order(by: ChatMessageModel.CodingKeys.dateCreated.rawValue, descending: true)
            .limit(to: 1)
            .getAllDocuments()
        
        return messages.first
    }
    
    func streamChatMessages(chatId: String, onListenerConfigured: @escaping (AnyListener) -> Void) -> AsyncThrowingStream<[ChatMessageModel], any Error> {
        messagesCollection(chatId: chatId).streamAllDocuments { listener in
            onListenerConfigured(AnyListener(listener: listener))
        }
    }
    
    func deleteChat(chatId: String) async throws {
        async let deleteChat: () = collection.deleteDocument(id: chatId)
        async let deleteMessages: () = messagesCollection(chatId: chatId).deleteAllDocuments()
        
        let (_, _) = await (try deleteChat, try deleteMessages)
    }
}
