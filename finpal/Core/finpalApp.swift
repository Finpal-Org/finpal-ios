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
    
    @StateObject private var viewRouter = TabBarViewRouter()
    
    var body: some Scene {
        WindowGroup {
            TabBarView(viewRouter: viewRouter)
                .environment(delegate.dependencies.receiptManager)
                .environment(delegate.dependencies.userManager)
        }
    }
}

@MainActor
struct Dependencies {
    let userManager: UserManager
    let receiptManager: ReceiptManager
    
    init() {
        userManager = UserManager(service: FirebaseUserService())
        receiptManager = ReceiptManager(service: FirebaseReceiptService())
    }
}

extension View {
    
    func previewEnvironment(isSignedIn: Bool = true) -> some View {
        self
            .environment(ReceiptManager(service: MockReceiptService()))
            .environment(UserManager(service: MockUserService(user: isSignedIn ? .mock : nil)))
            .environment(AppState())
    }
}
