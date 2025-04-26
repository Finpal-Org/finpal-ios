//
//  AIManager.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/21/25.
//

import SwiftUI
import Observation

@MainActor
@Observable class AIManager {
    private let service: AIService
    
    init(service: AIService) {
        self.service = service
    }
    
    func generateText(chats: [AIChatModel]) async throws -> AIChatModel {
        try await service.generateText(chats: chats)
    }
}

