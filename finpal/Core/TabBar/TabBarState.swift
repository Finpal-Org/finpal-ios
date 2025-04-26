//
//  TabBarState.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/19/25.
//

import SwiftUI

@Observable class TabBarState {
    var showLens = false
    
    func showVeryfiLens() {
        showLens = true
    }
    
    func dismissVeryfiLens() {
        showLens = false
    }
}
