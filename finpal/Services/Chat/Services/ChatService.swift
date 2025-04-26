//
//  ChatService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/27/25.
//

import Foundation

protocol ChatService: Sendable {
    func createNewChat(chat: ChatModel) async throws
    func getChat(userId: String, avatarId: String) async throws -> ChatModel?
    func addChatMessage(chatId: String, message: ChatMessageModel) async throws
    func getLastChatMessage(chatId: String) async throws -> ChatMessageModel?
    @MainActor func streamChatMessages(chatId: String, onListenerConfigured: @escaping (AnyListener) -> Void) -> AsyncThrowingStream<[ChatMessageModel], Error>
    func deleteChat(chatId: String) async throws
}
