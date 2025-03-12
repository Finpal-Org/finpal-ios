//
//  TabBarViewRouter.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/17/25.
//

import SwiftUI

class TabBarViewRouter: ObservableObject {
    @Published var currentPage: Page = .home
}

enum Page {
    case home
    case receipts
    case chatbot
    case profile
}
