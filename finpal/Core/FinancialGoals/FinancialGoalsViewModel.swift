//
//  FinancialGoalsViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI
import Observation

@Observable class FinancialGoalsViewModel {
    var name = ""
    var iconName = ""
    var amount = 0
    var difficultyValue = 0.5
    var deadline = Date()
    var contribution = 125
}
