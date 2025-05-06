//
//  GoalDetailsView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/7/25.
//

import SwiftUI

struct GoalDetailsView: View {
    let goal: GoalModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 54) {
                VStack(spacing: 32) {
                    navigationBar
                    titleSection
                }
                .padding(.top, 75)
                .padding(.bottom, 40)
                .background(Color.white)
                
                contributionsChart
                balancesSection
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.gray5)
        .ignoresSafeArea()
        
//        VStack {
//            VStack(spacing: 32) {
//                navigationBar
//                titleSection
//            }
//            .frame(maxWidth: .infinity)
//            .background(Color.red)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//        .background(Color.gray5)
    }
    
    private var navigationBar: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray80)
                .anyButton {
                    
                }
            
            Spacer()
            
            Text("Goal Details")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.gray80)
                .padding(.trailing)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    private var titleSection: some View {
        VStack(spacing: 32) {
            
            HStack(spacing: 8) {
                Image(systemName: goal.iconName)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundStyle(Color.gray60)
                
                Text(goal.name)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Color.gray80)
            }
            
            // Charts
            VStack {
                saveProgressChart
                
                HStack(alignment: .bottom, spacing: 36) {
                    monthlyChart
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray30, lineWidth: 1)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .frame(width: 48, height: 48)
                    .anyButton(.press) {
                        
                    }
                    
                    deadlineChart
                }
            }
        }
    }
    
    private var saveProgressChart: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.gray10, lineWidth: 20)
            
            // Progress ring
            Circle()
                .trim(from: 0.0, to: min(0.6, 1.0))
                .stroke(Color.brand60, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: 0.4)
            
            // Center label
            VStack(spacing: 4) {
                Text("SAR 1,22222222222")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.gray80)
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                
                Text("Saved So Far")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.gray60)
                
                Text("SAR\(goal.total) Total")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.gray40)
            }
            .padding(.horizontal, 20)
        }
        .frame(width: 168, height: 168)
    }
    
    private var monthlyChart: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.gray10, lineWidth: 16)
            
            // Progress ring
            Circle()
                .trim(from: 0.0, to: min(0.25, 1.0))
                .stroke(Color.gray60, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: 0.4)
            
            // Center label
            VStack(spacing: 4) {
                Text("SAR\(goal.monthlyContribution)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                
                Text("Monthly")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.gray60)
            }
            .padding(.horizontal, 20)
        }
        .frame(width: 110, height: 110)
    }
    
    private var deadlineChart: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.gray10, lineWidth: 16)
            
            // Progress ring
            Circle()
                .trim(from: 0.0, to: min(0.25, 1.0))
                .stroke(Color.warning30, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: 0.4)
            
            // Center label
            VStack(spacing: 4) {
                Text(DateFormatterUtility.shared.timeRemainingString(to: goal.deadline))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                
                Text("Remaining")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.gray60)
            }
            .padding(.horizontal, 20)
        }
        .frame(width: 110, height: 110)
    }
    
    private var contributionsChart: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Your Contributions")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.gray80)
                
                Spacer()
                
                Text("SAR25 this month")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.brand60)
                
            }
            
            MonthlyContributionsChartView(contributions: goal.contributions)
        }
        .padding(.horizontal, 16)
    }
    
    private var balancesSection: some View {
        VStack {
            Text("Balances")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            LazyVStack {
                ForEach(goal.contributions) { contribution in
                    balanceListItemView(contribution)
                }
            }
        }
    }
    
    private func balanceListItemView(_ contribution: ContributionModel) -> some View {
        HStack {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.gray5)
                    
                    Image(systemName: "arrow.down.to.line.alt")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.gray60)
                }
                .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Save")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.gray80)
                    
                    Text(DateFormatterUtility.shared.string(from: contribution.date, format: .dayAndMonth))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.gray60)
                }
            }
            
            Spacer()
            
            Text("+SAR\(contribution.amount)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.brand60)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    GoalDetailsView(goal: .mock)
}
