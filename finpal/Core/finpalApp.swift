//
//  finpalApp.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/6/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: Dependencies!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        dependencies = Dependencies()
        return true
    }
}

@main
struct finpalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(delegate.dependencies.receiptManager)
                .environment(delegate.dependencies.userManager)
                .environment(delegate.dependencies.authManager)
        }
    }
}

@MainActor
struct Dependencies {
    let authManager: AuthManager
    let userManager: UserManager
    let receiptManager: ReceiptManager
    
    init() {
        authManager = AuthManager(service: FirebaseAuthService())
        userManager = UserManager(services: ProductionUserServices())
        receiptManager = ReceiptManager(service: FirebaseReceiptService())
    }
}

extension View {
    
    func previewEnvironment(isSignedIn: Bool = true) -> some View {
        self
            .withRouter()
            .environment(ReceiptManager(service: MockReceiptService()))
            .environment(UserManager(services: MockUserServices(user: .mock)))
            .environment(AuthManager(service: MockAuthService(user: .mock)))
            .environment(TabBarViewModel())
            .environment(AppState())
    }
}
