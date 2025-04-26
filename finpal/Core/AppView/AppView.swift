//
//  AppView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/6/25.
//

import SwiftUI

struct AppView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    
    @State var appState = AppState()
    @State var tabBar = TabBarState()
    
    var body: some View {
        AppViewBuilder(
            showTabBar: appState.showTabBar,
            tabBar: {
                ZStack {
                    if appState.showAuthentication {
                        LoginView()
                    } else {
                        TabBarView()
                    }
                }
            },
            onboarding: {
                WelcomeView()
            }
        )
        .environment(tabBar)
        .environment(appState)
        .task {
            await checkUserStatus()
        }
        .onChange(of: appState.showTabBar) { _, showTabBar in
            print("showTabBar: \(showTabBar)")
            Task {
                await checkUserStatus()
            }
        }
    }
    
    private func checkUserStatus() async {
        if let user = authManager.auth {
            // User is authenticated
            print("User already authenticated: \(user.uid)")
            
            do {
                try await userManager.fetchUser(auth: user)
                appState.showAuthScreen(showAuth: false)
            } catch {
                print("Error fetching user data")
                do {
                    try authManager.signOut()
                } catch {
                    
                }
                appState.showAuthScreen(showAuth: true)
            }
            
        } else {
            // User is not authenticated
            appState.showAuthScreen(showAuth: true)
        }
    }
}

#Preview("AppView - TabBar") {
    AppView(appState: AppState(showTabBar: true))
        .previewEnvironment()
}

#Preview("AppView - Onboarding") {
    AppView(appState: AppState(showTabBar: false))
        .previewEnvironment()
}
