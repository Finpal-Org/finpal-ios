//
//  GoalCreatedConfirmationView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI

struct GoalCreatedConfirmationView: View {
    @State private var triggerConfetti = false
    
    let goal: GoalModel
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 24) {
                Image(.finpalGoalCreated)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                
                VStack(spacing: 12) {
                    Text("Goal Created")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color.gray80)
                        .confettiCannon(trigger: $triggerConfetti, num: 50)
                    
                    Text("You’re set to save SAR\(goal.total) by the \(DateFormatterUtility.shared.string(from: goal.deadline, format: .mediumDate)). Let’s Do It Now!")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.gray60)
                }
            }
            
            VStack {
                // Goal Name
                VStack {
                    HStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "list.clipboard")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.gray40)
                            
                            Text("Goal Name")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.gray80)
                        }
                        
                        Spacer()
                        
                        Text(goal.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    .padding(.vertical, 12)
                    
                    Divider()
                }
                
                // Goal Duration
                VStack {
                    HStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "calendar")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.gray40)
                            
                            Text("Goal Duration")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.gray80)
                        }
                        
                        Spacer()
                        
                        Text("\(DateFormatterUtility.shared.string(from: goal.deadline, format: .mediumDate)) (\(DateFormatterUtility.shared.timeRemainingString(to: goal.deadline)) from now)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    .padding(.vertical, 12)
                    
                    Divider()
                }
                
                // Goal Amount
                VStack {
                    HStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "banknote")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.gray40)
                            
                            Text("Goal Amount")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.gray80)
                        }
                        
                        Spacer()
                        
                        Text("SAR \(goal.total)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    .padding(.vertical, 12)
                    
                    Divider()
                }
                
                // Goal Difficulty
                VStack {
                    HStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "circlebadge.2")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.gray40)
                            
                            Text("Monthly Contribution")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.gray80)
                        }
                        
                        Spacer()
                        
                        Text("SAR \(goal.monthlyContribution)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    .padding(.vertical, 12)
                }
            }
            
            HStack {
                Image(systemName: "text.document")
                
                Text("Go to Overview")
            }
            .callToActionButton()
            
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray5)
        .onAppear {
            triggerConfetti.toggle()
        }
    }
}

#Preview {
    GoalCreatedConfirmationView(goal: GoalModel.mock)
}
