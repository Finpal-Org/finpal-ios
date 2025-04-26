//
//  AIAssistantView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/26/25.
//

import SwiftUI

struct AIAssistantView: View {
    @Environment(UserManager.self) private var userManager
    
    @State private var currentUser: UserModel?
    @State private var isLoading = true
    
    @State private var isChatPresented = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Hello")
                }
            }
            .navigationDestination(isPresented: $isChatPresented) {
                ChatbotChatView()
                    .navigationBarBackButtonHidden()
            }
            .task {
                await loadData()
            }
        }
    }
    
    private func loadData() async {
        try? await Task.sleep(for: .seconds(3))
        self.currentUser = UserModel.mock
        
        if let visitChatbot = currentUser?.didVisitChatbotScreen {
            
            if visitChatbot {
                isChatPresented = true
            } else {
                isChatPresented = false
            }
        }
        
        isLoading = false
    }
}

#Preview {
    AIAssistantView()
        .previewEnvironment()
}
