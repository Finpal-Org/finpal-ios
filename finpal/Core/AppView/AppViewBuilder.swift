//
//  AppViewBuilder.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/6/25.
//

import SwiftUI

struct AppViewBuilder<TabBarView: View, AuthView: View, OnboardingView: View>: View {
    let viewState: AppState.ViewState
    
    @ViewBuilder var tabBar: TabBarView
    @ViewBuilder var auth: AuthView
    @ViewBuilder var onboarding: OnboardingView
    
    var body: some View {
        ZStack {
            switch viewState {
            case .onboarding:
                onboarding
                    .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .trailing)))
            case .authentication:
                auth
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            case .tabBar:
                tabBar
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            }
        }
        .animation(.smooth, value: viewState)
    }
}

private struct PreviewView: View {
    @State private var appState = AppState()
    
    var body: some View {
        AppViewBuilder(
            viewState: appState.viewState,
            tabBar: {
                ZStack {
                    Color.red.ignoresSafeArea()
                    
                    Text("TabBar")
                }
                .onTapGesture {
                    appState.updateViewState(.authentication)
                }
            },
            auth: {
                ZStack {
                    Color.blue.ignoresSafeArea()
                    
                    Text("Authentication")
                }
                .onTapGesture {
                    appState.updateViewState(.tabBar)
                }
            },
            onboarding: {
                ZStack {
                    Color.green.ignoresSafeArea()
                    
                    Text("Onboarding")
                }
                .onTapGesture {
                    appState.updateViewState(.authentication)
                }
            }
        )
        .onAppear {
            appState.updateViewState(.onboarding)
        }
    }
}

#Preview {
    PreviewView()
}
