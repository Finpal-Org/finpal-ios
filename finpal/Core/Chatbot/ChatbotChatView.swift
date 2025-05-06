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
    @Environment(UserManager.self) private var userManager
    @Environment(ChatManager.self) private var chatManager
    @Environment(AIManager.self) private var aiManager
    @Environment(ReceiptManager.self) private var receiptManager
    
    @State private var chatMessages: [ChatMessageModel] = []
    @State private var myReceipts: [ReceiptModel] = []
    @State private var currentUser: UserModel?
    @State var chat: ChatModel?
    
    @State private var textFieldText: String = ""
    @State private var scrollPosition: String?
    
    @State private var isGeneratingResponse = false
    @State private var messageListener: AnyListener?
    
    private let avatarId = Constants.avatarId
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBarSection
            scrollViewSection
            textFieldSection
        }
        .animation(.easeInOut, value: isGeneratingResponse)
        .task {
            await loadData()
            await loadChat()
            await listenForChatMessages()
        }
        .onDisappear {
            messageListener?.listener.remove()
        }
    }
    
    private func loadData() async {
        self.currentUser = userManager.currentUser
        
        do {
//            let uid = try authManager.getAuthId()
//            myReceipts = try await receiptManager.getReceiptsForAuthor(userId: uid)
            myReceipts = ReceiptModel.mocks
        } catch {
            print("[finpal - DEBUG] Error loading receipts: \(error.localizedDescription)")
        }
    }
    
    private func loadChat() async {
        do {
            let uid = try authManager.getAuthId()
            chat = try await chatManager.getChat(userId: uid, avatarId: avatarId)
            
            if chat == nil {
                chat = try await createNewChat(uid: uid)
            }
        } catch {
            print("[finpal - DEBUG] No chat found for user: \(error.localizedDescription)")
        }
    }
    
    private func getChatId() throws -> String {
        guard let chat else {
            throw ChatViewError.noChat
        }
        return chat.id
    }
    
    private func listenForChatMessages() async {
        do {
            let chatId = try getChatId()
            
            for try await value in chatManager.streamChatMessages(chatId: chatId, onListenerConfigured: { listener in
                messageListener?.listener.remove()
                messageListener = listener
            }) {
                chatMessages = value.sortedByKeyPath(keyPath: \.dateCreatedCalculated, ascending: true)
                scrollPosition = chatMessages.last?.id
                
                if chatMessages.isEmpty {
                    sendStartMessage()
                }
                
                print("[finpal - DEBUG] ChatMessages: \(chatMessages.count)")
            }
        } catch {
            
        }
    }
    
    private func sendStartMessage() {
        if !chatMessages.isEmpty {
            return
        }
        
        Task {
            do {
                let uid = try authManager.getAuthId()
                
                if chat == nil {
                    chat = try await createNewChat(uid: uid)
                }
                
                guard let chat else {
                    throw ChatViewError.noChat
                }
                
                let newChatMessage = AIChatModel(
                    role: .assistant,
                    content: "Hello there! I'm finpal AI your personal AI finance assistant. How can I help you with your money today?"
                )
                
                let message = ChatMessageModel.newAIMessage(chatId: chat.id, avatarId: avatarId, message: newChatMessage)
                
                try await chatManager.addChatMessage(chatId: chat.id, message: message)
            } catch {
                
            }
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
                    NavigationLink {
                        ChatbotSettings()
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("Finpal AI Assistant")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.gray80)
                    }
                    
                    Text("GPT-4o")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.gray60)
                }
                
                Spacer()
            }
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
                        onImagePressed: nil
                    )
                    .id(message.id)
                }
                
                if isGeneratingResponse {
                    DotsAnimation(color: Color.gray60)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .rotationEffect(.degrees(180))
        }
        .background(Color.gray5)
        .rotationEffect(.degrees(180))
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .animation(.default, value: chatMessages.count)
        .animation(.default, value: scrollPosition)
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
                let uid = try authManager.getAuthId()
                
                if chat == nil {
                    chat = try await createNewChat(uid: uid)
                }
                
                guard let chat else {
                    throw ChatViewError.noChat
                }
                
                let newChatMessage = AIChatModel(role: .user, content: content)
                let message = ChatMessageModel.newUserMessage(chatId: chat.id, userId: uid, message: newChatMessage)
                
                try await chatManager.addChatMessage(chatId: chat.id, message: message)
                textFieldText = ""
                
                isGeneratingResponse = true
                
                let aiReceipts = myReceipts.map { receipt in
                    AIReceiptModel(
                        category: receipt.category.rawValue,
                        date: receipt.dateText,
                        total: receipt.total,
                        vendor: receipt.vendor?.name ?? ""
                    )
                }
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                encoder.dateEncodingStrategy = .iso8601

                guard let jsonData = try? encoder.encode(aiReceipts),
                      let jsonString = String(data: jsonData, encoding: .utf8) else {
                    print("Failed to encode simple receipts.")
                    return
                }
                
                print("[finpal - DEBUG] JSON string: \(jsonString)")
                
                var aiChats = chatMessages.compactMap({ $0.content })
                
                let prompt =
                """
                You are given a list of receipts for the current user.
                
                Each receipt includes the receipt category, vendor name, total, and date. Here is the data:
                
                \(jsonString)
                
                List the receipts with the category, vendor name, total, and date.
                
                Please return the receipt list as plain text, with each item on one line like this:
                [Category] Vendor - SARTotal on Date

                Example:
                [Meal] Starbucks - SAR44.61 on April 16, 2025
                """
                
                print("[finpal - DEBUG] Prompt: \(prompt)")
                
                let systemMessage = AIChatModel(
                    role: .system,
                    content: "You are a financial AI assistant. Do not answer any questions that are not related to finance."
                )
                
                aiChats.insert(systemMessage, at: 0)
                print("[finpal - DEBUG] System Message: \(systemMessage)")
                
                let userMessage = AIChatModel(
                    role: .user,
                    content: prompt
                )
                
                aiChats.insert(userMessage, at: 1)
                print("[finpal - DEBUG] User Message: \(userMessage)")
                
                let response = try await aiManager.generateText(chats: aiChats)
                
                print("[finpal - DEBUG] Response: \(response)")
                
                let newAIMessage = ChatMessageModel.newAIMessage(chatId: chat.id, avatarId: avatarId, message: response)
                
                try await chatManager.addChatMessage(chatId: chat.id, message: newAIMessage)
            } catch {
                print("[finpal - DEBUG] Error: \(error.localizedDescription)")
                print("[finpal - DEBUG] Error: \(error)")
            }
            
            isGeneratingResponse = false
        }
    }
    
    private func createNewChat(uid: String) async throws -> ChatModel {
        let newChat = ChatModel.new(userId: uid, avatarId: avatarId)
        try await chatManager.createNewChat(chat: newChat)
        
        defer {
            Task {
                await listenForChatMessages()
            }
        }
        
        return newChat
    }
    
    private func onBackButtonPressed() {
        dismiss()
    }
    
    enum ChatViewError: Error {
        case noChat
    }
}

#Preview {
    ChatbotChatView()
        .previewEnvironment()
}
