//
//  GoalsListItemView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI

struct GoalsListItemView: View {
    let goal: GoalModel
    
    var totalContributed: Int {
        goal.contributions.reduce(0) { $0 + $1.amount }
    }
    
    var completionPercentage: Double {
        let totalContributed = goal.contributions.reduce(0) { $0 + $1.amount }
        guard goal.total > 0 else { return 0 }
        return (Double(totalContributed) / Double(goal.total)) * 100
    }
    
    var isCompleted: Bool {
        let totalContributed = goal.contributions.reduce(0) { $0 + $1.amount }
        return totalContributed >= goal.total
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.gray5)
                    
                    Image(systemName: goal.iconName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.gray60)
                }
                .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.gray80)
                    
                    HStack(spacing: 4) {
                        Text("\(DateFormatterUtility.shared.timeRemainingString(to: goal.deadline)) remaining")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.gray60)
                        
                        Text("-")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.gray30)
                        
                        Text("\(completionPercentage, specifier: "%.0f")%")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.gray60)
                    }
                }
            }
            
            VStack(spacing: 8) {
                ProgressView(value: completionPercentage, total: 100)
                
                HStack {
                    (
                        Text("Saved ")
                            .font(.system(size: 14, weight: .regular))
                        +
                        Text("SAR 125,000")
                            .font(.system(size: 14, weight: .bold))
                        +
                        Text("/\(goal.total)")
                            .font(.system(size: 14, weight: .regular))
                    )
                    .foregroundStyle(Color.gray80)
                    
                    Spacer()
                    
                    if isCompleted {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.brand60)
                            
                            Text("Goal Completed")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(Color.gray60)
                        }
                    } else {
                        Text(DateFormatterUtility.shared.string(from: goal.deadline, format: .mediumDate))
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.gray60)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 24))
        .padding(.horizontal, 16)
        .mediumShadow()
    }
}

#Preview {
    ZStack {
        Color.gray5.ignoresSafeArea()
        
        GoalsListItemView(goal: .mock)
    }
}
