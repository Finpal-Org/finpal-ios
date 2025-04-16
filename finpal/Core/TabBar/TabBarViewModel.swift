//
//  TabBarViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/16/25.
//

import SwiftUI

@Observable class TabBarViewModel {
    var currentTab = TabSelection.home
    var showLens = false
    
    func updateCurrentTab(_ tab: TabSelection) {
        currentTab = tab
    }
}
