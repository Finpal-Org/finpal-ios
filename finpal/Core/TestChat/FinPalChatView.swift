//
//  FinPalChatView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/26/25.
//

import SwiftUI

struct Message: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
    let date = Date()
}

struct FinPalChatView: View {
    // Network service
    private let networkService = FinPalNetworkService()
    
    // State
    @State private var messages: [Message] = []
    @State private var inputText = ""
    @State private var isConnected = false
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            // Connection status
            if !isConnected {
                HStack {
                    Text("Connecting...")
                    ProgressView()
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            
            // Messages
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                }
                .onChange(of: messages) { _, _ in
                    if let lastMessage = messages.last {
                        scrollView.scrollTo(lastMessage.id)
                    }
                }
            }
            
            // Loading indicator
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Text("Thinking...")
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            
            // Input area
            HStack {
                TextField("Type a message...", text: $inputText)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .disabled(!isConnected || isLoading)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
                .disabled(!isConnected || inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
            }
            .padding()
        }
        .onAppear {
            connect()
        }
    }
    
    private func connect() {
        Task {
            do {
                isConnected = try await networkService.connectToServer()
                
                if isConnected {
                    messages.append(Message(
                        content: "Hello! I'm FinPal, your financial assistant. How can I help you today?",
                        isFromUser: false
                    ))
                }
            } catch {
                messages.append(Message(
                    content: "Connection error: \(error.localizedDescription)",
                    isFromUser: false
                ))
            }
        }
    }
    
    private func sendMessage() {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let userMessage = Message(content: trimmedText, isFromUser: true)
        messages.append(userMessage)
        
        let messageText = inputText
        inputText = ""
        isLoading = true
        
        Task {
            do {
                let response = try await networkService.processQuery(messageText)
                messages.append(Message(content: response, isFromUser: false))
            } catch {
                messages.append(Message(
                    content: "Error: \(error.localizedDescription)",
                    isFromUser: false
                ))
            }
            isLoading = false
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            
            Text(message.content)
                .padding(12)
                .background(message.isFromUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.isFromUser ? .white : .primary)
                .cornerRadius(16)
                .frame(maxWidth: 280, alignment: message.isFromUser ? .trailing : .leading)
            
            if !message.isFromUser {
                Spacer()
            }
        }
    }
}

#Preview {
    FinPalChatView()
}
