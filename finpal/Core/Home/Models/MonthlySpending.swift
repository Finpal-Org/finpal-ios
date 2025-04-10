//
//  MonthlySpending.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/10/25.
//

import Foundation

struct MonthlySpending: Identifiable, Hashable {
    var id = UUID()
    var amount: Double
    var month: String
    var isCurrentMonth: Bool
    
    static var defaultData: [Self] {
        [
            MonthlySpending(amount: 0, month: "Jan", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Feb", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Mar", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Apr", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "May", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Jun", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Jul", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Aug", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Sep", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Oct", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Nov", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Dec", isCurrentMonth: false),
        ]
    }
    
    static var targetData: [Self] {
        [
            MonthlySpending(amount: 17, month: "Jan", isCurrentMonth: false),
            MonthlySpending(amount: 5.3, month: "Feb", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Mar", isCurrentMonth: false),
            MonthlySpending(amount: 17, month: "Apr", isCurrentMonth: false),
            MonthlySpending(amount: 15.5, month: "May", isCurrentMonth: false),
            MonthlySpending(amount: 25, month: "Jun", isCurrentMonth: true),
            MonthlySpending(amount: 43.5, month: "Jul", isCurrentMonth: false),
            MonthlySpending(amount: 25, month: "Aug", isCurrentMonth: false),
            MonthlySpending(amount: 2, month: "Sep", isCurrentMonth: false),
            MonthlySpending(amount: 0, month: "Oct", isCurrentMonth: false),
            MonthlySpending(amount: 70, month: "Nov", isCurrentMonth: true),
            MonthlySpending(amount: 10, month: "Dec", isCurrentMonth: false),
        ]
    }
}
