//
//  ChatBubbleViewBuilder.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/21/25.
//

import SwiftUI

struct ChatBubbleViewBuilder: View {
    var message: ChatMessageModel = .mock
    var isCurrentUser: Bool = false
    var onImagePressed: (() -> Void)?
    
    var body: some View {
        ChatBubbleView(
            text: message.content?.message ?? "",
            textColor: isCurrentUser ? .white : Color.gray80,
            showImage: !isCurrentUser,
            onImagePressed: onImagePressed
        )
        .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
        .padding(isCurrentUser ? .leading : .trailing, 75)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            ChatBubbleViewBuilder()
            
            ChatBubbleViewBuilder(isCurrentUser: true)
            
            ChatBubbleViewBuilder(
                message: ChatMessageModel(
                    id: UUID().uuidString,
                    chatId: UUID().uuidString,
                    authorId: UUID().uuidString,
                    content: AIChatModel(role: .user, content: "This is some longer content that goes on to multiple lines and keeps on going to another line!"),
                    dateCreated: .now
                )
            )
            
            ChatBubbleViewBuilder(
                message: ChatMessageModel(
                    id: UUID().uuidString,
                    chatId: UUID().uuidString,
                    authorId: UUID().uuidString,
                    content: AIChatModel(role: .user, content: "This is some longer content that goes on to multiple lines and keeps on going to another line!"),
                    dateCreated: .now
                ),
                isCurrentUser: true,
            )
        }
        .padding(12)
    }
}
