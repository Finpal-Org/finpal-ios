//
//  NavigationPathOption.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/21/25.
//

import SwiftUI

enum NavigationPathOption: Hashable {
    case setup(email: String, password: String)
    case receipt(receipt: ReceiptModel)
    case chatbotSettings
    case profileSettings
    case exportData
}

extension View {
    
    func navigationDestinationForCoreModule(path: Binding<[NavigationPathOption]>) -> some View {
        navigationDestination(for: NavigationPathOption.self) { newValue in
            Group {
                switch newValue {
                case .setup(email: let email, password: let password):
                    ProfileSetupView(email: email, password: password)
                case .receipt(receipt: let receipt):
                    ReceiptDetailsView(receipt: receipt)
                case .chatbotSettings:
                    ChatbotSettings()
                case .profileSettings:
                    ProfileSettingsView()
                case .exportData:
                    ExportDataView()
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}
