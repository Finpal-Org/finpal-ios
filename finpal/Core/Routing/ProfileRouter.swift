//
//  ProfileRouter.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/24/25.
//

import SwiftUI

enum ProfileRouter: Hashable {
    case profileInfo
    case profileAppearance
    case profileExport
    case profileAbout
    case changePassword
}

extension View {
    
    func withProfileRouter(path: Binding<[ProfileRouter]>) -> some View {
        navigationDestination(for: ProfileRouter.self) { newValue in
            Group {
                switch newValue {
                case .profileInfo:
                    ProfileSettingsView()
                case .profileAppearance:
                    AppearanceModeView()
                case .profileExport:
                    ExportDataView()
                case .profileAbout:
                    AboutUsView()
                case .changePassword:
                    ChangePasswordView()
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}
