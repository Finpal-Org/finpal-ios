//
//  AuthenticationRouter.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/5/25.
//

import SwiftUI

@Observable
class AuthenticationRouter {
    var path = NavigationPath()
    
    func navigateToLogin() {
        path.append(Route.login)
    }
    
    func navigateToSignUp() {
        path.append(Route.signUp)
    }
    
    func navigateToSetup(email: String, password: String) {
        path.append(Route.setup(email: email, password: password))
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

enum Route: Hashable {
    case login
    case signUp
    case setup(email: String, password: String)
}
