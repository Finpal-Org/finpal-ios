//
//  ChatbotChatView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/20/25.
//

import SwiftUI

struct ChatbotChatView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @Environment(AIManager.self) private var aiManager
    
    @State private var chatMessages: [ChatMessageModel] = []
    
    @State private var textFieldText: String = ""
    @State private var scrollPosition: String?
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBarSection
            scrollViewSection
            textFieldSection
        }
    }
    
    private var navigationBarSection: some View {
        HStack(spacing: 20) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray80)
                .anyButton {
                    onBackButtonPressed()
                }
            
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .frame(width: 48, height: 48)
                        .foregroundStyle(Color.white)
                    
                    Image(.finpalChatbotRobot)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Finpal AI Assistant")
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("GPT-4o")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.gray60)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.gray10)
        .border(width: 1, edges: [.bottom], color: Color.gray30)
    }
    
    private var scrollViewSection: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(chatMessages) { message in
                    let isCurrentUser = message.authorId == authManager.auth?.uid
                    
                    ChatBubbleViewBuilder(
                        message: message,
                        isCurrentUser: isCurrentUser,
                        imageName: isCurrentUser ? nil : Constants.randomImageURL,
                        onImagePressed: nil
                    )
                    .id(message.id)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
        .background(Color.gray5)
    }
    
    private var textFieldSection: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "microphone")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.gray60)
                    .frame(width: 20, height: 20)
                    .padding(.leading, 12)
                
                TextField("", text: $textFieldText, axis: .vertical)
                    .placeholder(when: textFieldText.isEmpty) {
                        Text("Type to start chatting...")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.gray60)
                    }
                    .lineLimit(5)
                    .font(.system(size: 14, weight: .regular))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.gray80)
                    .padding(.vertical, 16)
                    .padding(.trailing, 12)
            }
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.gray30, lineWidth: 1)
                    .background(Color.white, in: .rect(cornerRadius: 24))
            }
            
            ZStack {
                Circle()
                    .stroke(Color.brand60, lineWidth: 1)
                    .frame(width: 48, height: 48)
                
                Image(systemName: "paperplane")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.brand60)
            }
            .padding(.leading, 12)
            .background(Color.clear)
            .anyButton(.press) {
                onSendMessagePressed()
            }
        }
        .padding(16)
        .background(Color.gray10)
        .border(width: 1, edges: [.top], color: Color.gray30)
    }
    
    private func onSendMessagePressed() {
        let content = textFieldText
        
        Task {
            do {
                
            } catch {
                
            }
        }
    }
    
    private func onBackButtonPressed() {
        dismiss()
    }
}

#Preview {
    ChatbotChatView()
        .previewEnvironment()
}
