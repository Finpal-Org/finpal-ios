//
//  ProfileView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/10/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    
    @State private var currentUser: UserModel?
    
    @State private var showPopup = false
    @State private var errorMessage = ""
    
    @State private var isSignOutAlertPresented = false
    @State private var isDeleteAlertPresented = false
    @State private var deleteAlertText = ""
    
    var body: some View {
        ScrollView {
            VStack {
                StickyHeaderView(currentUser: currentUser)
                
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
        .signOutAlert(isPresented: $isSignOutAlertPresented) {
            onSignOutConfirmedPressed()
        }
        .deleteAlert(isPresented: $isDeleteAlertPresented, deleteText: $deleteAlertText) {
            onDeleteAccountConfirmedPressed()
        }
        .task {
            await loadData()
        }
    }
    
    private func loadData() async {
        self.currentUser = userManager.currentUser
    }
    
    private var generalSettingsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("General Settings")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.leading)
            
            VStack(spacing: 8) {
                ProfileSettingsItemView(setting: .profileInfo) {
                    onProfileSettingsPressed()
                }
                
                ProfileSettingsItemView(setting: .displayAppearance) {
                    onAppearanceModePressed()
                }
                
                ProfileSettingsItemView(setting: .exportData) {
                    onExportDataButtonPressed()
                }
                
                ProfileSettingsItemView(setting: .aboutUs) {
                    onAboutUsButtonPressed()
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
            
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(Color.gray5)
                        
                        Image(systemName: "bell")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.gray60)
                    }
                    
                    Text("Push Notification")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.gray80)
                }
                
                Spacer()
                
                Toggle("", isOn: .constant(true))
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(Color.white, in: .rect(cornerRadius: 20))
            .padding(.horizontal, 16)
            .mediumShadow()
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
                onDeleteAccountPressed()
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
        .frame(height: 75)
        .padding(.bottom, 90)
    }
    
    private func onProfileSettingsPressed() {
        
    }
    
    private func onAppearanceModePressed() {
        
    }
    
    private func onExportDataButtonPressed() {
        
    }
    
    private func onAboutUsButtonPressed() {
        
    }
    
    private func onDeleteAccountPressed() {
        isDeleteAlertPresented.toggle()
    }
    
    private func onDeleteAccountConfirmedPressed() {
        Task {
            do {
                
                try await userManager.deleteCurrentUser()
                try await authManager.deleteAccount()
                
                appState.showAuthScreen(showAuth: true)
            } catch {
                errorMessage = "Failed to delete your account. Please try again later."
                showPopup = true
            }
        }
    }
    
    private func onSignOutPressed() {
        isSignOutAlertPresented.toggle()
    }
    
    private func onSignOutConfirmedPressed() {
        Task {
            do {
                try authManager.signOut()
                userManager.signOut()
                
                appState.showAuthScreen(showAuth: true)
            } catch {
                errorMessage = "Sign out failed. Please try again."
                showPopup = true
            }
        }
    }
}

#Preview {
    ProfileView()
        .previewEnvironment()
}
