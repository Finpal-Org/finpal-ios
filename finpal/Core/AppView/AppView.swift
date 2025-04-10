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
    
    @StateObject private var viewRouter = TabBarViewRouter()
    
    var body: some View {
        AppViewBuilder(
            viewState: appState.viewState,
            tabBar: {
                TabBarView(viewRouter: viewRouter)
            },
            auth: {
                LoginView()
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
    }
    
    private func checkUserStatus() async {
        if let user = authManager.auth {
            // User is authenticated
            print("User already authenticated: \(user.uid)")
            
            do {
                try await userManager.fetchUser(auth: user)
                appState.updateViewState(.tabBar)
            } catch {
                print("Error fetching user data")
                appState.updateViewState(.authentication)
            }
            
        } else {
            // User is not authenticated
            
        }
    }
}

#Preview("AppView - TabBar") {
    AppView()
        .previewEnvironment()
}

#Preview("AppView - Onboarding") {
    AppView()
        .previewEnvironment()
}
