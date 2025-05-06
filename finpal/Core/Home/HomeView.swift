//
//  HomeView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/10/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(ReceiptManager.self) private var receiptManager
    
    @State private var myReceipts: [ReceiptModel] = []
    @State private var monthlySpending: [Double] = []
    @State private var totalSpendingThisMonth: Double = 0
    @State private var percentChangeFromLastMonth: Double = 0
    @State private var mostSpentCategories: [TopCategory] = []
    
    @State private var isLoading = true
    
    @State private var showPopup = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack {
                        HeaderAndChartView(spending: monthlySpending, percentChange: percentChangeFromLastMonth)
                        MostSpentCategoriesView(topCategories: mostSpentCategories)
                        LatestReceiptsView()
                        TargetGoalsView()
                    }
                }
                .scrollIndicators(.hidden)
                .background(Color.gray5)
                .ignoresSafeArea(.all)
                .onAppear {
                    updateSpendingDataFromReceipts()
                    updateTopFiveCategories()
                }
            }
        }
        .task {
            await loadData()
        }
        .errorPopup(showingPopup: $showPopup, errorMessage)
    }
    
    private func loadData() async {
        do {
            let uid = try authManager.getAuthId()
            myReceipts = try await receiptManager.getReceiptsForAuthor(userId: uid)
        } catch {
            errorMessage = "Failed to fetch user's receipts. Please try again."
            showPopup = true
        }
        
        isLoading = false
    }
    
    private func updateSpendingDataFromReceipts() {
        let calendar = Calendar.current
        let now = Date()
        
        // Extract current month and year
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)
        
        // Filter receipts for the current month
        let filteredReceipts = myReceipts.filter { receipt in
            let receiptYear = calendar.component(.year, from: receipt.date)
            let receiptMonth = calendar.component(.month, from: receipt.date)
            return receiptYear == currentYear && receiptMonth == currentMonth
        }
        
        // Convert to Double array, starting with 0.0
        monthlySpending = [0.0] + filteredReceipts.map { Double($0.total) }
        
        // Use the helper to calculate total for this and last month
        let (thisMonthTotal, lastMonthTotal) = calculateMonthlySpendings()
        
        // Update @State values
        totalSpendingThisMonth = thisMonthTotal
        
        if lastMonthTotal != 0 {
            percentChangeFromLastMonth = ((thisMonthTotal - lastMonthTotal) / lastMonthTotal) * 100
        } else {
            percentChangeFromLastMonth = 0
        }
    }
    
    private func calculateMonthlySpendings() -> (thisMonth: Double, lastMonth: Double) {
        let calendar = Calendar.current
        let now = Date()
        
        // Get year/month components for current date
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        // Get components for last month, handling year rollover (e.g. Jan -> Dec)
        var lastMonthDateComponents = DateComponents(year: currentYear, month: currentMonth - 1)
        if currentMonth == 1 {
            lastMonthDateComponents.year = currentYear - 1
            lastMonthDateComponents.month = 12
        }
        
        // Get start and end dates of both months
        let thisMonthStart = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1))!
        let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: thisMonthStart)!
        
        let lastMonthStart = calendar.date(from: lastMonthDateComponents)!
        let thisMonthEnd = calendar.date(byAdding: .second, value: -1, to: nextMonthStart)!
        let lastMonthEnd = calendar.date(byAdding: .second, value: -1, to: thisMonthStart)!
        
        // Filter and sum totals
        let thisMonthTotal = myReceipts
            .filter { $0.date >= thisMonthStart && $0.date <= thisMonthEnd }
            .reduce(0.0) { $0 + Double($1.total) }
        
        let lastMonthTotal = myReceipts
            .filter { $0.date >= lastMonthStart && $0.date <= lastMonthEnd }
            .reduce(0.0) { $0 + Double($1.total) }
        
        return (thisMonthTotal, lastMonthTotal)
    }
    
    private func updateTopFiveCategories() {
        // Step 1: Group totals by category
        var categoryTotals: [CategoryModel: Double] = [:]
        
        for receipt in myReceipts {
            let amount = Double(receipt.total)
            categoryTotals[receipt.category, default: 0.0] += amount
        }
        
        // Step 2: Convert to TopCategory and sort by amount
        var topCategories = categoryTotals
            .map { TopCategory(category: $0.key, total: $0.value) }
            .sorted { $0.total > $1.total }
        
        // Step 3: Add zero-value categories if fewer than 5 exist
        let existingCategories = Set(topCategories.map { $0.category })
        let missingCategories = CategoryModel.allCases.filter { !existingCategories.contains($0) }
        
        for category in missingCategories.prefix(5 - topCategories.count) {
            topCategories.append(TopCategory(category: category, total: 0.0))
        }
        
        mostSpentCategories = Array(topCategories.prefix(5))
    }
}

#Preview {
    HomeView()
        .previewEnvironment()
}
