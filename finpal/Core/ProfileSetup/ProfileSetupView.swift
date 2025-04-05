//
//  ProfileSetupView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/26/25.
//

import SwiftUI

struct ProfileSetupView: View {
    @Environment(AuthenticationRouter.self) private var router
    
    @State private var currentIndex: Int = 0
    @State private var viewModel: ProfileSetupViewModel
    
    init(email: String, password: String) {
        self.viewModel = ProfileSetupViewModel(
            email: email,
            password: password,
            fullName: "",
            monthlyIncome: 10_000,
            savingsPercentage: 25.0
        )
    }
    
    var body: some View {
        ZStack {
            Color.gray5.ignoresSafeArea()
            
            profileSetupScreens()
            
            if currentIndex >= 5 {
                ProfileSetupLoadingView()
                    .transition(.move(edge: .trailing))
            } else {
                navigationBar()
            }
        }
    }
    
    @ViewBuilder
    private func profileSetupScreens() -> some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack {
                ForEach(0...4, id: \.self) { index in
                    screenView(size: size, index: index)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private func screenView(size: CGSize, index: Int) -> some View {
        switch index {
        case 0:
            NameInputView(
                size: size,
                currentIndex: $currentIndex,
                fullName: $viewModel.fullName
            )
        case 1:
            IncomeInputView(
                size: size,
                currentIndex: $currentIndex,
                monthlyIncome: $viewModel.monthlyIncome
            )
        case 2:
            SavingsPercentageInputView(
                size: size,
                currentIndex: $currentIndex,
                sliderValue: $viewModel.savingsPercentage
            )
        case 3:
            ProfileImageUploadView(
                size: size,
                currentIndex: $currentIndex,
                viewModel: viewModel
            )
        case 4:
            NotificationsInputView(size: size, currentIndex: $currentIndex)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func navigationBar() -> some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray80)
                .anyButton {
                    if currentIndex > 0 {
                        currentIndex -= 1
                    } else {
                        router.navigateToSignUp()
                    }
                }
            
            ProgressView(value: Double(currentIndex) / 5)
                .finpalProgressBar()
                .animation(.easeIn, value: currentIndex)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
}

extension View {
    
    func addTitleAnimation(size: CGSize, index: Int, currentIndex: Int) -> some View {
        self
            .offset(x: -size.width * CGFloat(currentIndex - index))
            .animation(
                .interactiveSpring(
                    response: 0.9,
                    dampingFraction: 0.8,
                    blendDuration: 0.5
                ).delay(
                    currentIndex == index ? 0.2 : 0
                ).delay(
                    currentIndex == index ? 0.2 : 0
                ),
                value: currentIndex
            )
    }
    
    func addSubtitleAnimation(size: CGSize, index: Int, currentIndex: Int) -> some View {
        self
            .offset(x: -size.width * CGFloat(currentIndex - index))
            .animation(
                .interactiveSpring(
                    response: 0.9,
                    dampingFraction: 0.8,
                    blendDuration: 0.5
                ).delay(
                    0.1
                ).delay(
                    currentIndex == index ? 0.2 : 0
                ),
                value: currentIndex
            )
    }
    
    func addButtonAnimation(size: CGSize, index: Int, currentIndex: Int) -> some View {
        self
            .offset(x: -size.width * CGFloat(currentIndex - index))
            .animation(
                .interactiveSpring(
                    response: 0.9,
                    dampingFraction: 0.8,
                    blendDuration: 0.5
                ).delay(
                    currentIndex == index ? 0 : 0.2
                ).delay(
                    currentIndex == index ? 0.2 : 0
                ),
                value: currentIndex
            )
    }
    
}

private struct PreviewView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ProfileSetupView(email: email, password: password)
            .withRouter()
    }
}

#Preview {
    PreviewView()
}
