//
//  WelcomeView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/6/25.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack(spacing: 64) {
            VStack(spacing: 0) {
                Image(.logoPlain)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                
                Text("finpal")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Your Smart Personal AI Finance Assistant")
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top)
            }
            
            VStack(spacing: 12) {
                featuresItemView("Auto Scan & Store Receipts")
                featuresItemView("Smart Budget Management")
                featuresItemView("Arabic OCR Support")
                featuresItemView("AI-Powered Insights")
                featuresItemView("Financial Goals Tracking")
            }
            
            buttonView
        }
        .padding()
    }
    
    private var buttonView: some View {
        HStack {
            Text("Get Started")
            
            Image(systemName: "arrow.right")
        }
        .callToActionButton()
        .anyButton(.press) {
            router.navigateToOnboarding()
        }
    }
    
    private func featuresItemView(_ title: String) -> some View {
        Label {
            Text(title)
                .font(.callout)
                .fontWeight(.medium)
        } icon: {
            Image(systemName: "checkmark.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.accent)
        }
    }
}

#Preview {
    WelcomeView()
        .previewEnvironment()
}
