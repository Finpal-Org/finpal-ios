//
//  RouterViewModifier.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/5/25.
//

import SwiftUI

struct RouterViewModifier: ViewModifier {
    @State private var router = Router()
    
    private func routeView(for route: Route) -> some View {
        Group {
            switch route {
            case .onboarding:
                OnboardingView()
            case .login:
                LoginView()
            case .register:
                Text("Register")
            case .setup(let email, let password):
                ProfileSetupView(email: email, password: password)
            case .tabBar:
                TabBarView()
            case .receiptDetails(let receipt):
                ReceiptDetailsView(receipt: receipt)
            case .exportData:
                ExportDataView()
            }
        }
        .navigationBarBackButtonHidden()
        .environment(router)
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
