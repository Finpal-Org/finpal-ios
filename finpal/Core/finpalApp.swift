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
                .environment(delegate.dependencies.goalManager)
                .environment(delegate.dependencies.chatManager)
                .environment(delegate.dependencies.aiManager)
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
    let aiManager: AIManager
    let receiptManager: ReceiptManager
    let chatManager: ChatManager
    let goalManager: GoalsManager
    
    init() {
        authManager = AuthManager(service: FirebaseAuthService())
        userManager = UserManager(services: ProductionUserServices())
        aiManager = AIManager(service: OpenAIService())
        receiptManager = ReceiptManager(service: FirebaseReceiptService())
        chatManager = ChatManager(service: FirebaseChatService())
        goalManager = GoalsManager(service: FirebaseGoalService())
    }
}

extension View {
    
    func previewEnvironment() -> some View {
        self
            .withRouter()
            .environment(GoalsManager(service: MockGoalService()))
            .environment(ChatManager(service: MockChatService()))
            .environment(AIManager(service: MockAIService()))
            .environment(ReceiptManager(service: MockReceiptService()))
            .environment(UserManager(services: MockUserServices(user: .mock)))
            .environment(AuthManager(service: MockAuthService(user: .mock)))
            .environment(TabBarState())
            .environment(AppState())
    }
}
