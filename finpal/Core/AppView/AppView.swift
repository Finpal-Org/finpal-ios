//
//  AppView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/6/25.
//

import SwiftUI

// tabbar - signed in
// onboarding - new user
// sign in - signed out

struct AppView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    
    @State var appState: AppState = AppState()
    
    @State private var currentUser: UserModel?
    @State private var showAuthScreen: Bool = false
    
    @StateObject private var viewRouter = TabBarViewRouter()
    
    var body: some View {
        AppViewBuilder(
            showTabBar: appState.showTabBar,
            tabBar: {
                if showAuthScreen {
                    AuthenticationView()
                } else {
                    TabBarView(viewRouter: viewRouter)
                }
            },
            onboarding: {
                WelcomeView()
            }
        )
        .withRouter()
        .environment(appState)
        .task {
            await checkUserStatus()
        }
        .onChange(of: appState.showTabBar) { _, showTabBar in
            if !showTabBar {
                Task {
                    await checkUserStatus()
                }
            }
        }
    }
    
    private func loadData() async {
        self.currentUser = userManager.currentUser
    }
    
    private func checkUserStatus() async {
        if let user = authManager.auth {
            // User is authenticated
            print("User already authenticated: \(user.uid)")
            
            do {
                try await userManager.login(auth: user)
            } catch {
                print("Failed to log in to auth for existing user: \(error)")
                try? await Task.sleep(for: .seconds(5))
                await checkUserStatus()
            }
            
        } else {
            // User is not authenticated
            showAuthScreen = true
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
