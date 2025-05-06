//
//  Router.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/19/25.
//

import SwiftUI
import Observation

@Observable class Router {
    var path = NavigationPath()
    
    func navigateToOnboarding() {
        path.append(Route.onboarding)
    }
    
    func navigateToLogin() {
        path.append(Route.login)
    }
    
    func navigateToRegister() {
        path.append(Route.register)
    }
    
    func navigateToSetup(email: String, password: String) {
        path.append(Route.setup(email: email, password: password))
    }
    
    func navigateToTabBar() {
        path.append(Route.tabBar)
    }
}

enum Route: Hashable {
    case onboarding
    case login
    case register
    case setup(email: String, password: String)
    case tabBar
}
