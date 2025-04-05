//
//  NotificationsInputView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/26/25.
//

import SwiftUI

struct NotificationsInputView: View {
    var size: CGSize
    
    @Binding var currentIndex: Int
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            titleView
            imageView
            buttonsView
            
            Spacer()
        }
    }
    
    private var titleView: some View {
        VStack(spacing: 12) {
            Text("Enable Notifications")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Text("Enable push notifications to stay on top of your finances with updates on balances and goals made for you.")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
                .padding(.horizontal, 32)
        }
        .addTitleAnimation(size: size, index: 4, currentIndex: currentIndex)
    }
    
    private var imageView: some View {
        VStack(spacing: 20) {
            Image(.enableNotifications)
                .resizable()
                .scaledToFit()
            
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(Color.gray60)
                
                Text("You can change this setting anytime.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.gray60)
            }
        }
        .addSubtitleAnimation(size: size, index: 4, currentIndex: currentIndex)
    }
    
    private var buttonsView: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Enable Notifications")
                
                Image(systemName: "checkmark")
            }
            .callToActionButton()
            .anyButton(.press) {
                
            }
            .padding(.horizontal)
            
            Text("Nope, maybe later")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.brand60)
                .anyButton {
                    onSkipButtonPressed()
                }
        }
        .addButtonAnimation(size: size, index: 4, currentIndex: currentIndex)
    }
    
    private func onSkipButtonPressed() {
        withAnimation(.smooth.delay(0.5)) {
            currentIndex += 1
        }
    }
}

#Preview {
    @Previewable @State var currentIndex: Int = 4
    
    GeometryReader { geometry in
        let size = geometry.size
        
        NotificationsInputView(size: size, currentIndex: $currentIndex)
    }
}
