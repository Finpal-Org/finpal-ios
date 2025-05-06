//
//  GoalsListView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI

struct GoalsListView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(GoalsManager.self) private var goalManager
    
    @State private var myGoals: [GoalModel] = []
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack {
                titleSection
                goalsSection
                
                Spacer()
                
                addGoalButton
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.gray5)
        .ignoresSafeArea()
        .task {
            await loadData()
        }
    }
    
    private func loadData() async {
        do {
            let uid = try authManager.getAuthId()
//            myGoals = try await goalManager.getAllGoals(userId: uid)
            myGoals = GoalModel.mocks
        } catch {
            
        }
        
        isLoading = false
    }
    
    private var navigationBar: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray80)
                .anyButton {
                    
                }
            
            Spacer()
            
            Text("My Goals")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.gray80)
                .padding(.trailing)
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    private var titleSection: some View {
        VStack {
            navigationBar
            
            VStack(spacing: 24) {
                Image(.finpalMyGoals)
                
                VStack(spacing: 12) {
                    Text("Everything begins with a step")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.gray80)
                    
                    Text("Here's a list of all your goals")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.gray60)
                }
                
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 340)
        .background(Color.brand10)
    }
    
    private var noGoalsFound: some View {
        VStack(spacing: 24) {
            Image(systemName: "dollarsign.bank.building")
                .font(.system(size: 48))
                .foregroundStyle(Color.gray40)
            
            VStack(spacing: 12) {
                Text("No financial goals found")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                
                Text("It looks like you don’t have any goals. Once you add one, it will appear here.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.gray60)
            }
        }
    }
    
    private var goalsSection: some View {
        VStack {
            if myGoals.isEmpty {
                Group {
                    if isLoading {
                        ProgressView()
                    } else {
                        noGoalsFound
                    }
                }
                .padding(.vertical, 50)
                .padding(.horizontal, 16)
            } else {
                HStack {
                    Text("My Goals")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.gray80)
                    
                    Spacer()
                    
                    Text("\(myGoals.count) Total")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.gray40)
                }
                
                LazyVStack {
                    ForEach(myGoals) { goal in
                        
                    }
                }
                
            }
        }
    }
    
    private var addGoalButton: some View {
        HStack {
            Text("Add New Goal")
            
            Image(systemName: "plus")
        }
        .callToActionButton()
    }
}

#Preview {
    GoalsListView()
        .previewEnvironment()
}
