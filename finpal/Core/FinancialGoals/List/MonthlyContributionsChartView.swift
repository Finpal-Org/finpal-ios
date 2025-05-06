//
//  MonthlyContributionsChartView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/7/25.
//

import SwiftUI
import Charts

struct BarChartResponse: Identifiable, Hashable {
    let id = UUID()
    let month: String
    let amount: Int
}

struct MonthlyContributionsChartView: View {
    let contributions: [ContributionModel]
    
    @State private var data: [BarChartResponse] = []
    
    var body: some View {
        Chart {
            ForEach(data) { contribution in
                BarMark(
                    x: .value("Month", contribution.month),
                    y: .value("Amount", contribution.amount)
                )
                .foregroundStyle(isInCurrentMonth(contribution.month) ? Color.brand60 : Color.gray20)
                .clipShape(BarRoundedRectangle())
                .annotation(position: .top, spacing: 2) {
                    if contribution.amount > 0 {
                        Text("SAR\(contribution.amount)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.gray60)
                    }
                }
            }
        }
        .frame(height: 206)
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(position: .bottom) { month in
                AxisValueLabel()
                    .font(.system(size: 12, weight: .regular))
                
                AxisValueLabel {
                    if let string = month.as(String.self) {
                        if isInCurrentMonth(string) {
                            Text(string)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Color.gray80)
                        } else {
                            Text(string)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(Color.gray60)
                        }
                    }
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 6)
        .chartScrollTargetBehavior(.paging)
        .onAppear {
            data = convertToBarChartData(from: contributions)
        }
    }
    
    func convertToBarChartData(from contributions: [ContributionModel]) -> [BarChartResponse] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM" // "Jan", "Feb", etc.

        // Group and sum by month
        var monthlySums: [String: Int] = [:]

        for contribution in contributions {
            let month = dateFormatter.string(from: contribution.date)
            let roundedAmount = Int(contribution.amount)
            monthlySums[month, default: 0] += roundedAmount
        }

        // Build BarChartResponse for all 12 months
        let allMonths = dateFormatter.shortMonthSymbols ?? []
        
        let result = allMonths.map { month in
            BarChartResponse(month: month, amount: monthlySums[month] ?? 0)
        }

        return result
    }
    
    func isInCurrentMonth(_ month: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let currentMonth = formatter.string(from: Date())
        return month == currentMonth
    }
}

#Preview {
    MonthlyContributionsChartView(contributions: ContributionModel.mocks)
}
