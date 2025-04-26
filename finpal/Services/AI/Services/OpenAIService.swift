//
//  OpenAIService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/21/25.
//

import SwiftUI
import OpenAI

private typealias ChatCompletion = ChatQuery.ChatCompletionMessageParam
private typealias SystemMessage = ChatQuery.ChatCompletionMessageParam.SystemMessageParam
private typealias DeveloperMessage = ChatQuery.ChatCompletionMessageParam.DeveloperMessageParam
private typealias UserMessage = ChatQuery.ChatCompletionMessageParam.UserMessageParam
private typealias UserTextContent = ChatQuery.ChatCompletionMessageParam.UserMessageParam.Content
private typealias AssistantMessage = ChatQuery.ChatCompletionMessageParam.AssistantMessageParam

struct OpenAIService: AIService {
    var openAI: OpenAI {
        OpenAI(apiToken: Keys.openAIKey)
    }
    
    func generateText(chats: [AIChatModel]) async throws -> AIChatModel {
        let messages = chats.compactMap({ $0.toOpenAIModel() })
        let query = ChatQuery(messages: messages, model: .gpt4_o)
        let result = try await openAI.chats(query: query)
        
        guard
            let chat = result.choices.first?.message,
            let model = AIChatModel(chat: chat)
        else {
            throw OpenAIError.invalidResponse
        }
        
        return model
    }
    
    enum OpenAIError: LocalizedError {
        case invalidResponse
    }
}

struct AIChatModel: Codable {
    let role: AIChatRole
    let message: String
    
    init(role: AIChatRole, content: String) {
        self.role = role
        self.message = content
    }
    
    init?(chat: ChatResult.Choice.Message) {
        self.role = AIChatRole(role: chat.role)
        
        if let string = chat.content {
            self.message = string
        } else {
            return nil
        }
    }
    
    fileprivate func toOpenAIModel() -> ChatCompletion? {
        switch role {
        case .system:
            return ChatCompletion.system(SystemMessage(content: message))
        case .developer:
            return ChatCompletion.developer(DeveloperMessage(content: message))
        case .user:
            return ChatCompletion.user(UserMessage(content: UserTextContent(string: message)))
        case .assistant:
            return ChatCompletion.assistant(AssistantMessage(content: message))
        case .tool:
            return nil
        }
    }
}

enum AIChatRole: String, Codable {
    case system, developer, user, assistant, tool
    
    init(role: String) {
        switch role {
        case "system":
            self = .system
        case "developer":
            self = .developer
        case "user":
            self = .user
        case "assistant":
            self = .assistant
        case "tool":
            self = .tool
        default:
            self = .system
        }
    }
    
    var openAIRole: ChatQuery.ChatCompletionMessageParam.Role {
        switch self {
        case .system:
            return .system
        case .developer:
            return .developer
        case .user:
            return .user
        case .assistant:
            return .assistant
        case .tool:
            return .tool
        }
    }
}
