//
//  ChatbotSettings.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/29/25.
//

import SwiftUI

struct ChatbotSettings: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @Environment(ChatManager.self) private var chatManager
    
    @State private var dataSharingEnabled = true
    @State private var showingAlert = false
    
    @State private var showPopup = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                navigationBar
                titleSection
            }
            
            VStack(spacing: 24) {
                privacySection
                clearChatSection
            }
            
            Spacer()
            
            saveButton
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
        .errorPopup(showingPopup: $showPopup, errorMessage)
    }
    
    private var navigationBar: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray80)
                .anyButton {
                    onBackButtonPressed()
                }
            
            Spacer()
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Chat Settings")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Text("Customize your AI finance companion")
                .font(.system(size: 16))
                .foregroundStyle(Color.gray60)
        }
        .padding(.vertical, 16)
    }
    
    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Privacy & Data")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            VStack(spacing: 24) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Data Sharing")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.gray80)
                        
                        Text("Description goes here...")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.gray60)
                    }
                    
                    Toggle("", isOn: $dataSharingEnabled)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.white, in: .rect(cornerRadius: 20))
                .mediumShadow()
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Export Assistant Data")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.gray80)
                        
                        Text("Export your assistant data with ease.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.gray60)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.white, in: .rect(cornerRadius: 20))
                .mediumShadow()
            }
        }
    }
    
    private var clearChatSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Clear Chat History")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Text("This will delete all previous conversations, memory appearance and other things. Are you sure to delete this?")
                .font(.system(size: 16))
                .foregroundStyle(Color.gray60)
            
            HStack {
                Image(systemName: "trash")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.destructive50)
                
                Text("Clear Data")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.destructive60)
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(Color.destructive5, in: .capsule)
            .anyButton(.press) {
                showingAlert = true
            }
        }
        .alert(
            "Clear Chat History?",
            isPresented: $showingAlert,
            actions: {
                Button("Cancel", role: .cancel) { }
                
                Button("Delete", role: .destructive) {
                    onDeleteChatPressed()
                }
            },
            message: {
                Text("This will permanently delete all your messages with the chatbot. This action cannot be undone.")
            }
        )
    }
    
    private var saveButton: some View {
        Text("Save Settings")
            .callToActionButton()
            .anyButton(.press) {
                
            }
    }
    
    private func onBackButtonPressed() {
        dismiss()
    }
    
    private func onDeleteChatPressed() {
        Task {
            do {
                let uid = try authManager.getAuthId()
                let chat = try await chatManager.getChat(userId: uid, avatarId: Constants.avatarId)
                
                guard let chat else {
                    errorMessage = "Unable to find chat history. Please try again later."
                    showPopup = true
                    return
                }
                
                try await chatManager.deleteChat(chatId: chat.id)
                
                try await Task.sleep(for: .seconds(1))
                dismiss()
            } catch {
                errorMessage = "Something went wrong while deleting the chat. Please try again."
                showPopup = true
            }
        }
    }
    
}

#Preview {
    ChatbotSettings()
        .previewEnvironment()
}
