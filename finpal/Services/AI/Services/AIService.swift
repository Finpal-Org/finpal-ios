//
//  AIService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/21/25.
//

import SwiftUI

protocol AIService: Sendable {
    func generateText(chats: [AIChatModel]) async throws -> AIChatModel
}
