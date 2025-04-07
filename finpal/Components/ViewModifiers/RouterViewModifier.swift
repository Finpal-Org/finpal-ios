//
//  RouterViewModifier.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/5/25.
//

import SwiftUI

struct RouterViewModifier: ViewModifier {
    @State private var router = AuthenticationRouter()
    
    private func routeView(for route: Route) -> some View {
        Group {
            switch route {
            case .onboarding:
                OnboardingView()
            case .login:
                LoginView()
            case .signUp:
                RegistrationView()
            case .setup(email: let email, password: let password):
                ProfileSetupView(email: email, password: password)
            }
        }
        .environment(router)
        .navigationBarBackButtonHidden()
    }
    
    func body(content: Content) -> some View {
        NavigationStack(path: $router.path) {
            content
                .environment(router)
                .navigationDestination(for: Route.self) { route in
                    routeView(for: route)
                }
        }
    }
}

extension View {
    
    func withRouter() -> some View {
        modifier(RouterViewModifier())
    }
}
