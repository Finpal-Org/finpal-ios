//
//  MockChatService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/27/25.
//

import SwiftUI

@MainActor
class MockChatService: ChatService {
    
    let chat: ChatModel
    @Published private var messages: [ChatMessageModel]
    let delay: Double
    let showError: Bool
    
    init(
        chat: ChatModel = ChatModel.mock,
        messages: [ChatMessageModel] = ChatMessageModel.mocks,
        delay: Double = 0.0,
        showError: Bool = false
    ) {
        self.chat = chat
        self.messages = messages
        self.delay = delay
        self.showError = showError
    }
    
    private func tryShowError() throws {
        if showError {
            throw URLError(.unknown)
        }
    }
    
    func createNewChat(chat: ChatModel) async throws {
        
    }
    
    func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        
        if chat.userId == userId && chat.avatarId == avatarId {
            return chat
        }
        
        return nil
    }
    
    func addChatMessage(chatId: String, message: ChatMessageModel) async throws {
        messages.append(message)
    }
    
    func getLastChatMessage(chatId: String) async throws -> ChatMessageModel? {
        try await Task.sleep(for: .seconds(delay))
        try tryShowError()
        
        return ChatMessageModel.mocks.randomElement()
    }
    
    func streamChatMessages(chatId: String, onListenerConfigured: @escaping (AnyListener) -> Void) -> AsyncThrowingStream<[ChatMessageModel], Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(messages)
            
            Task {
                for await value in $messages.values {
                    continuation.yield(value)
                }
            }
        }
    }
    
    func deleteChat(chatId: String) async throws {
        
    }
}
