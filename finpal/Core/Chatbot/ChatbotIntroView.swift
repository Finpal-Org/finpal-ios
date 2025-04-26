//
//  ChatbotIntroView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/21/25.
//

import SwiftUI

struct ChatbotIntroView: View {
    var body: some View {
        VStack(spacing: 32) {
            Image(.finpalChatbotIntro)
                .resizable()
                .scaledToFit()
                .padding(16)
            
            VStack(spacing: 12) {
                Text("Meet Your Personal Finance Assistant")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                
                Text("Meet finpal, your personal finance assistant to help you with your money management.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.gray60)
                    .padding(.horizontal, 18)
                    .lineSpacing(4)
            }
            
            HStack {
                Text("Get Started")
                
                Image(systemName: "arrow.right")
            }
            .callToActionButton()
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray5)
    }
}

#Preview {
    ChatbotIntroView()
}
