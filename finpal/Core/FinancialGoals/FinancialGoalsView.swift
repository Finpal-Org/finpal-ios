//
//  FinancialGoalsView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/5/25.
//

import SwiftUI

struct FinancialGoalsView: View {
    @Environment(UserManager.self) private var userManager
    @Environment(AuthManager.self) private var authManager
    @Environment(GoalsManager.self) private var goalManager
    
    enum Screens {
        case welcome
        case name
        case icon
        case amount
        case difficulty
        case deadline
        case contribution
        case loading
        case created
    }
    
    let screens: [Screens] = [
        .welcome,
        .name,
        .icon,
        .amount,
        .difficulty,
        .deadline,
        .contribution,
        .loading,
        .created
    ]
    
    @State private var viewModel = FinancialGoalsViewModel()
    
    @State private var currentUser: UserModel?
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            Image(.logoPlain)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            GeometryReader { proxy in
                let size = proxy.size
                
                ZStack {
                    ForEach(Array(screens.enumerated()), id: \.element) { index, item in
                        screenView(to: item)
                            .offset(x: -size.width * CGFloat(currentPage - index))
                            .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5), value: currentPage)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray5)
        .onAppear {
            loadCurrentUser()
        }
    }
    
    private func loadCurrentUser() {
        currentUser = userManager.currentUser
    }
    
    @ViewBuilder
    private func screenView(to screen: Screens) -> some View {
        switch screen {
        case .welcome:
            GoalOnboardingWelcomeView(page: $currentPage, name: currentUser?.firstName)
        case .name:
            GoalNameInputView(page: $currentPage, text: $viewModel.name)
        case .icon:
            GoalIconSelectionView(page: $currentPage, selectedIcon: $viewModel.iconName)
        case .amount:
            GoalAmountInputView(page: $currentPage, amount: $viewModel.amount)
        case .difficulty:
            GoalDifficultyView(page: $currentPage, sliderValue: $viewModel.difficultyValue)
        case .deadline:
            GoalDeadlinePickerView(page: $currentPage)
        case .contribution:
            GoalMonthlyContributionView(
                page: $currentPage,
                monthlyContribution: $viewModel.contribution,
                amount: $viewModel.amount,
                deadline: viewModel.deadline
            )
        case .loading:
            GoalCreationLoadingView()
        case .created:
            Text("")
        }
    }
    
    private func createNewGoal() {
        Task {
            do {
                let uid = try authManager.getAuthId()
                
                let goal = GoalModel.newGoal(
                    name: viewModel.name,
                    iconName: viewModel.iconName,
                    total: viewModel.amount,
                    difficulty: Int(viewModel.difficultyValue),
                    deadline: viewModel.deadline,
                    monthlyContribution: viewModel.contribution,
                    userId: uid
                )
                
                try await goalManager.createNewGoal(goal: goal)
            } catch {
                
            }
        }
    }
}

#Preview {
    FinancialGoalsView()
        .previewEnvironment()
}
