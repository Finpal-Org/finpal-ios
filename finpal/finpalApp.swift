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
            ContentView()
        }
    }
}

@MainActor
struct Dependencies {
    let userManager: UserManager
    
    init() {
        userManager = UserManager(service: FirebaseUserService())
    }
}

extension View {
    
    func previewEnvironment(isSignedIn: Bool = true) -> some View {
        self
            .environment(UserManager(service: MockUserService(user: isSignedIn ? .mock : nil)))
            .environment(AppState())
    }
}
