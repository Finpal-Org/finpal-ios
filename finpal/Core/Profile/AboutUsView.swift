//
//  AboutUsView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/24/25.
//

import SwiftUI

struct AboutUsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            navigationBar
            
            ScrollView {
                VStack(spacing: 24) {
                    Image(.finpalAboutUs)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 204)
                    
                    titleView
                    
                    VStack(spacing: 12) {
                        informationSection
                        featuresSection
                        contactSection
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
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
        .padding(16)
    }
    
    private var titleView: some View {
        VStack(spacing: 8) {
            Text("About Us")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Text("finpal AI, Inc.")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            Text("Copyright © 2025 All Rights Reserved")
                .font(.system(size: 16))
                .foregroundStyle(Color.gray60)
        }
    }
    
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle.text.page")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.gray60)
                
                Text("Information")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.gray80)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("finpal AI is an intelligent finance companion designed to simplify money management and help you achieve your financial goals.")
                
                Text("Our AI-powered app provides personalized insights, budgeting tools, and real-time tracking to empower you with financial clarity. Whether you're saving, investing, or just staying on top of expenses, finpal AI is here to guide you every step of the way.")
            }
            .tracking(0.6)
            .font(.system(size: 14))
            .foregroundStyle(Color.gray60)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white, in: .rect(cornerRadius: 20))
        .padding(.horizontal, 16)
        .mediumShadow()
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.gray60)
                
                Text("Features")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.gray80)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Label("Smart Receipt Scanning", systemImage: "checkmark")
                Label("Automated Budgeting", systemImage: "checkmark")
                Label("Goal Tracking", systemImage: "checkmark")
                Label("AI-Powered Insights", systemImage: "checkmark")
                Label("Secure & Private", systemImage: "checkmark")
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(Color.gray60)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: .rect(cornerRadius: 20))
        .padding(.horizontal, 16)
        .mediumShadow()
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "phone")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.gray60)
                
                Text("Contact Us")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.gray80)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Got questions? Reach us at")
                
                Text("support@finpal.ai")
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(Color.gray60)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: .rect(cornerRadius: 20))
        .padding(.horizontal, 16)
        .mediumShadow()
    }
    
    private func onBackButtonPressed() {
        dismiss()
    }
}

#Preview {
    AboutUsView()
}
