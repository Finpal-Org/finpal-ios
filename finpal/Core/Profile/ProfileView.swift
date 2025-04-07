//
//  ProfileView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/10/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(AppState.self) private var appState
    
    @State private var currentUser: UserModel?
    
    @State private var showPopup = false
    @State private var errorMessage = ""
    
    var body: some View {
        ScrollView {
            VStack {
                StickyHeaderView()
                
                VStack(spacing: 32) {
                    generalSettingsView
                    
                    Divider()
                        .padding(.horizontal)
                    
                    notificationsSettingsView
                    
                    Divider()
                        .padding(.horizontal)
                    
                    securitySettingsView
                    
                    Divider()
                        .padding(.horizontal)
                    
                    dangerZoneSectionView
                    signOutButton
                }
                
            }
        }
        .ignoresSafeArea()
        .background(Color.gray5)
        .errorPopup(showingPopup: $showPopup, errorMessage)
    }
    
    private var generalSettingsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("General Settings")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.leading)
            
            VStack(spacing: 8) {
                ProfileSettingsItemView(setting: .profileInfo) {
                    
                }
                
                ProfileSettingsItemView(setting: .displayAppearance) {
                    
                }
                
                ProfileSettingsItemView(setting: .exportData) {
                    
                }
                
                ProfileSettingsItemView(setting: .aboutUs) {
                    
                }
            }
        }
    }
    
    private var notificationsSettingsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notifications")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.leading)
            
            ProfileSettingsItemView(setting: .pushNotification) {
                
            }
        }
    }
    
    private var securitySettingsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Security")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.leading)
            
            ProfileSettingsItemView(setting: .changePassword) {
                
            }
        }
    }
    
    private var dangerZoneSectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Danger Zone")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.gray80)
                
                Spacer()
                
                Text("Careful")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.gray40)
            }
            .padding(.horizontal)
            
            ProfileSettingsItemView(setting: .deleteAccount, isImportant: true) {
                
            }
        }
    }
    
    private var signOutButton: some View {
        VStack {
            
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.destructive60)
                
                Text("Sign Out")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.destructive60)
            }
            .anyButton {
                onSignOutPressed()
            }
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(.bottom, 60)
    }
    
    private func onSignOutPressed() {
        Task {
            do {
                try authManager.signOut()
                userManager.signOut()
                
                await dismissScreen()
            } catch {
                errorMessage = "Sign out failed. Please try again."
                showPopup = true
            }
        }
    }
    
    private func dismissScreen() async {
        try? await Task.sleep(for: .seconds(1))
        appState.updateViewState(showTabBar: false)
    }
}

#Preview {
    ProfileView()
        .previewEnvironment()
}
