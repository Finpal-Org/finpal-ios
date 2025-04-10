//
//  BarChartView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/10/25.
//

import SwiftUI
import Charts

struct BarChartView: View {
    @State private var defaultData: [MonthlySpending] = MonthlySpending.defaultData
    @State private var targetData: [MonthlySpending] = MonthlySpending.targetData
    
    var body: some View {
        Chart {
            ForEach(defaultData) { data in
                BarMark(
                    x: .value("Month", data.month),
                    y: .value("Amount", data.amount)
                )
                .foregroundStyle(data.isCurrentMonth ? Color.brand60 : Color.brand20)
                .clipShape(BarRoundedRectangle())
                .annotation(position: .top) {
                    if data.amount != 0 {
                        Text("SAR \(data.amount.trimmedDecimalString)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(Color.gray80)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { value in
                AxisValueLabel {
                    if let month = value.as(String.self) {
                        Text(month)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.gray60)
                    }
                }
                .offset(y: 8)
            }
        }
        .chartYAxis(.hidden)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 6)
        .chartScrollTargetBehavior(.paging)
        .onAppear {
            animateChart()
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    private func animateChart() {
        for (index, target) in targetData.enumerated() {
            withAnimation(.easeInOut(duration: 1.0).delay(Double(index) * 0.1)) {
                defaultData[index].amount = target.amount
                defaultData[index].isCurrentMonth = target.isCurrentMonth
            }
        }
    }
}

#Preview {
    VStack {
        BarChartView()
    }
    .frame(maxWidth: .infinity)
    .frame(height: 164)
    .padding(16)
    .background(Color.white, in: .rect(cornerRadius: 24))
    .padding(.horizontal, 16)
    .mediumShadow()
}
