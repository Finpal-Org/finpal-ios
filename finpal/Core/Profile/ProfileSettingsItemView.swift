//
//  ProfileSettingsItemView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/8/25.
//

import SwiftUI

enum ProfileSettings: String {
    case profileInfo = "Profile Info"
    case displayAppearance = "Display & Appearance"
    case exportData = "Export Data"
    case changePassword = "Change Password"
    case aboutUs = "About Us"
    case pushNotification = "Push Notification"
    case deleteAccount = "Delete Account"
    
    var iconName: String {
        switch self {
        case .profileInfo:
            return "person"
        case .displayAppearance:
            return "paintpalette"
        case .exportData:
            return "arrow.down.document"
        case .changePassword:
            return "lock"
        case .aboutUs:
            return "questionmark"
        case .pushNotification:
            return "bell"
        case .deleteAccount:
            return "exclamationmark.triangle"
        }
    }
}

struct ProfileSettingsItemView: View {
    let setting: ProfileSettings
    let isImportant: Bool
    let action: () -> Void
    
    init(setting: ProfileSettings, isImportant: Bool = false, action: @escaping () -> Void) {
        self.setting = setting
        self.isImportant = isImportant
        self.action = action
    }
    
    var body: some View {
        HStack {
            
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(isImportant ? Color.destructive5 : Color.gray5)
                    
                    Image(systemName: setting.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(isImportant ? Color.destructive50 : Color.gray60)
                }
                
                Text(setting.rawValue)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.gray80)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.gray40)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .frame(height: 64)
        .background(Color.white, in: .rect(cornerRadius: 20))
        .padding(.horizontal, 16)
        .mediumShadow()
        .anyButton(.press) {
            action()
        }
    }
}

#Preview {
    ZStack {
        Color.gray5.ignoresSafeArea()
        
        VStack {
            ProfileSettingsItemView(setting: .profileInfo) {
                
            }
            
            ProfileSettingsItemView(setting: .deleteAccount, isImportant: true) {
                
            }
        }
    }
}
