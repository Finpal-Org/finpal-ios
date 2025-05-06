//
//  GoalMonthlyContributionView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI

struct GoalMonthlyContributionView: View {
    @Binding var page: Int
    @Binding var monthlyContribution: Int
    @Binding var amount: Int
    
    let deadline: Date
    
    var body: some View {
        VStack {
            Text("How much would you like to contribute each month?")
                .multilineTextAlignment(.leading)
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color.gray80)
                .tracking(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack(spacing: 48) {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Monthly Contribution")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.gray80)
                        
                        HStack {
                            ZStack {
                                Circle()
                                    .stroke(Color.gray30, lineWidth: 1)
                                    .fill(Color.white)
                                
                                Image(systemName: "minus")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundStyle(Color.gray60)
                            }
                            .frame(width: 48, height: 48)
                            .anyButton(.press) {
                                if monthlyContribution > 5 {
                                    monthlyContribution -= 5
                                }
                            }
                            
                            Spacer()
                            
                            Text("SAR \(monthlyContribution)")
                                .font(.system(size: 48, weight: .semibold))
                                .foregroundStyle(Color.brand60)
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .stroke(Color.gray30, lineWidth: 1)
                                    .fill(Color.white)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundStyle(Color.gray60)
                            }
                            .frame(width: 48, height: 48)
                            .anyButton(.press) {
                                monthlyContribution += 5
                            }
                        }
                    }
                    
                    (
                        Text("I'll save ")
                            .font(.system(size: 16, weight: .regular))
                        +
                        Text("SAR\(monthlyContribution) ")
                            .font(.system(size: 16, weight: .bold))
                        +
                        Text("every month for ")
                            .font(.system(size: 16, weight: .regular))
                        +
                        Text(timeRemainingString(to: deadline))
                            .font(.system(size: 16, weight: .bold))
                    )
                    .foregroundStyle(Color.gray60)
                }
                
                VStack(spacing: 12) {
                    Text("with an end date of")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.gray60)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(Color.brand60)
                        
                        Text(DateFormatterUtility.shared.string(from: deadline, format: .mediumDate))
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(Color.gray80)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background {
                        Capsule()
                            .stroke(Color.gray30, lineWidth: 1)
                            .background(Color.white, in: .capsule)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12) {
                HStack {
                    Text("Create")
                    
                    Image(systemName: "arrow.right")
                }
                .callToActionButton()
                .frame(width: 140)
                .anyButton(.press) {
                    page += 1
                }
                
                HStack {
                    Image(systemName: "chevron.left")
                    
                    Text("Go Back")
                }
                .secondaryButton()
                .frame(width: 162)
                .anyButton(.press) {
                    page -= 1
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .onChange(of: amount) { _, _ in
            calculateMonthlyContribution()
        }
    }
    
    private func calculateMonthlyContribution() {
        monthlyContribution = amount / 2
    }
    
    private func timeRemainingString(to endDate: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        
        let start = calendar.startOfDay(for: now)
        let end = calendar.startOfDay(for: endDate)
        
        if start == end {
            return "Today"
        }
        
        // Calculate full difference in years, months, and days
        let components = calendar.dateComponents([.year, .month, .day], from: start, to: end)
        var years = components.year ?? 0
        var months = components.month ?? 0
        let days = components.day ?? 0
        
        // Round up months if days are significant (e.g., >= 25)
        if days >= 25 {
            months += 1
        }
        
        // Convert 12 months to 1 year if needed
        if months >= 12 {
            years += months / 12
            months = months % 12
        }
        
        var parts: [String] = []
        
        if years > 0 {
            parts.append("\(years)y")
        }
        if months > 0 {
            parts.append("\(months)m")
        }
        
        return parts.isEmpty ? "0m" : parts.joined(separator: " ")
    }
}

#Preview {
    @Previewable @State var contribution = 125
    @Previewable @State var amount = 5000
    GoalMonthlyContributionView(
        page: .constant(6),
        monthlyContribution: $contribution,
        amount: $amount,
        deadline: .now.addingTimeInterval(days: 460)
    )
}
