//
//  ChatBubbleView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/21/25.
//

import SwiftUI

struct ChatBubbleView: View {
    var text: String = "This is a sample text."
    var textColor: Color = .primary
    var showImage: Bool = true
    var onImagePressed: (() -> Void)?
    
    let offset: CGFloat = 14
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if showImage {
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    Image(.finpalChatbotRobot)
                        .font(.system(size: 20))
                }
                .frame(width: 40, height: 40)
                .clipShape(.circle)
            }
            
            if showImage {
                Text(text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(textColor)
                    .padding(16)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray20, lineWidth: 1)
                            .background(Color.white, in: .rect(cornerRadius: 16))
                    }
            } else {
                Text(text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(textColor)
                    .padding(16)
                    .background(Color.brand60)
                    .clipShape(.rect(cornerRadius: 16))
            }
        }
        .padding(.bottom, showImage ? offset : 0)
    }
}

#Preview {
    ChatBubbleView()
}
