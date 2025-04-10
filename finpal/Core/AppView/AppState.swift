//
//  AppState.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/6/25.
//

import SwiftUI

@Observable class AppState {
    enum ViewState {
        case onboarding
        case authentication
        case tabBar
    }
    
    private(set) var viewState: ViewState
    
    init() {
        if !UserDefaults.hasCompletedOnboarding {
            self.viewState = .onboarding
        } else if UserDefaults.isUserAuthenticated {
            self.viewState = .tabBar
        } else {
            self.viewState = .authentication
        }
    }
    
    func updateViewState(_ newState: ViewState) {
        print("AppState - Updating state from \(self.viewState) to \(newState)")
        
        self.viewState = newState
        
        // Update UserDefaults based on the new state
        if newState == .authentication || newState == .tabBar {
            UserDefaults.hasCompletedOnboarding = true
        }
        
        if newState == .tabBar {
            UserDefaults.isUserAuthenticated = true
        }
        
        print("AppState - State updated to \(self.viewState)")
    }
    
    // Convenience computed property for backward compatibility
    var showTabBar: Bool {
        return viewState == .tabBar
    }
}

extension UserDefaults {
    
    private struct Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let isUserAuthenticated = "isUserAuthenticated"
        static let showTabBar = "showTabBar"
    }
    
    static var hasCompletedOnboarding: Bool {
        get {
            standard.bool(forKey: Keys.hasCompletedOnboarding)
        } set {
            standard.set(newValue, forKey: Keys.hasCompletedOnboarding)
        }
    }
    
    static var isUserAuthenticated: Bool {
        get {
            standard.bool(forKey: Keys.isUserAuthenticated)
        } set {
            standard.set(newValue, forKey: Keys.isUserAuthenticated)
        }
    }
    
    static var showTabBar: Bool {
        get {
            standard.bool(forKey: Keys.showTabBar)
        } set {
            standard.set(newValue, forKey: Keys.showTabBar)
        }
    }
}
