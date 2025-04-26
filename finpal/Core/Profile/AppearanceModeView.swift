//
//  AppearanceModeView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/24/25.
//

import SwiftUI

struct AppearanceModeView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedMode: AppearanceMode = .light
    
    enum AppearanceMode: String {
        case light = "Light Mode"
        case dark = "Dark Mode"
        case system = "Use System Settings"
        
        var systemNameIcon: String {
            switch self {
            case .light:
                return "sun.max.fill"
            case .dark:
                return "moon"
            case .system:
                return "desktopcomputer"
            }
        }
    }
    
    var body: some View {
        VStack {
            navigationBar
            
            Spacer()
            
            VStack(spacing: 32) {
                Image(.finpalAppearanceMode)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                
                titleView
                
                VStack(spacing: 12) {
                    appearanceButton(.light)
                    appearanceButton(.dark)
                    appearanceButton(.system)
                }
            }
            
            Spacer()
            
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
        VStack(spacing: 12) {
            Text("Appearance Mode")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Text("Here you can customize your mode")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
        }
    }
    
    private func appearanceButton(_ mode: AppearanceMode) -> some View {
        HStack {
            
            HStack(spacing: 8) {
                Image(systemName: mode.systemNameIcon)
                    .font(.system(size: 28))
                    .foregroundStyle(mode == .light ? Color.yellow : Color.gray40)
                
                Text(mode.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.gray80)
            }
            
            Spacer()
            
            if selectedMode == mode {
                Image(systemName: "checkmark")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.brand60)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white, in: .rect(cornerRadius: 24))
        .padding(.horizontal, 16)
        .mediumShadow()
        .anyButton(.press) {
            selectedMode = mode
        }
    }
    
    private func onBackButtonPressed() {
        dismiss()
    }
    
}

#Preview {
    AppearanceModeView()
}
