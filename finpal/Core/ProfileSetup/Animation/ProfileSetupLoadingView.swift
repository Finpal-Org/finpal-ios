//
//  ProfileSetupLoadingView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/27/25.
//

import SwiftUI
import ConfettiSwiftUI

struct ProfileSetupLoadingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(AuthenticationRouter.self) private var router
    @Environment(AppState.self) private var appState
    
    let viewModel: ProfileSetupViewModel
    
    @State private var showCircle: Int = 0
    @State private var rotateCheckMark: Int = 30
    @State private var showCheckMark: Int = -60
    
    @State private var showLoading: Bool = false
    @State private var rotateLoading: Double = 0.35
    
    @State private var showFailLoading = false
    @State private var isXMarkPresented = false
    @State private var isTryAgainPresented = false
    
    @State private var showPopup = false
    @State private var errorMessage = ""
    
    @State private var isSpinnerComplete: Bool = false
    @State private var isCheckMarkComplete: Bool = false
    @State private var isAnimationComplete: Bool = false
    
    var body: some View {
        ZStack {
            if isCheckMarkComplete {
                animationView
            } else {
                loadingView
            }
        }
        .safeAreaInset(edge: .bottom, alignment: .center, spacing: 16) {
            ZStack {
                if isTryAgainPresented {
                    Text("Try Again")
                        .callToActionButton()
                        .anyButton(.press) {
                            onTryAgainButtonPressed()
                        }
                }
                
                if isAnimationComplete {
                    continueButton
                }
            }
            .transition(.move(edge: .bottom))
            .padding(24)
        }
        .animation(.bouncy, value: isTryAgainPresented)
        .animation(.bouncy, value: isAnimationComplete)
        .onChange(of: showFailLoading) { _, newValue in
            if newValue {
                Task {
                    completeCircleAnimation()
                    
                    await showCircleSymbol()
                    await showTryAgainButton()
                    
                    if !showFailLoading {
                        try? await Task.sleep(for: .seconds(1))
                        withAnimation(.snappy) {
                            isSpinnerComplete.toggle()
                        }
                        
                        try? await Task.sleep(for: .seconds(3))
                        withAnimation(.bouncy) {
                            isCheckMarkComplete.toggle()
                        }
                    }
                }
            }
            
        }
        .errorPopup(showingPopup: $showPopup, errorMessage)
    }
    
    private var circleAnimation: some View {
        ZStack {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundStyle(showFailLoading ? Color.destructive60 : Color.brand60)
                .scaleEffect(CGFloat(showCircle))
                .animation(.interpolatingSpring(stiffness: 170, damping: 15).delay(0.5), value: showCircle)
            
            Image(systemName: isXMarkPresented ? "xmark" : "checkmark")
                .font(.system(size: 30))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(Double(rotateCheckMark)))
                .clipShape(.rect.offset(x: CGFloat(showCheckMark)))
                .animation(.interpolatingSpring(stiffness: 170, damping: 15).delay(1.0), value: showCheckMark)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 32) {
            ZStack {
                circleAnimation
                
                CircularLoaderView()
                    .opacity(showLoading ? 0 : 1)
                
                Circle()
                    .stroke(lineWidth: 8)
                    .opacity(0.3)
                    .foregroundStyle(.gray)
                    .frame(width: 64)
                
                Circle()
                    .trim(from: 0, to: rotateLoading)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(showFailLoading ? Color.destructive60 : Color.brand60)
                    .frame(width: 64)
                    .animation(.linear, value: rotateLoading)
                    .opacity(showLoading ? 1 : 0)
            }
            .task {
                await startLoading()
            }
            
            Group {
                if isSpinnerComplete {
                    Text("Your account was successfully created!")
                } else {
                    if showFailLoading {
                        Text("Failed to create your account! Please try again.")
                    } else {
                        Text("Creating a personalized financial experience...")
                    }
                }
            }
            .multilineTextAlignment(.center)
            .font(.system(size: 24, weight: .regular))
            .foregroundStyle(Color.gray80)
            .padding(.horizontal, 36)
            .confettiCannon(
                trigger: $isSpinnerComplete,
                num: 100,
                radius: 400
            )
        }
    }
    
    private var animationView: some View {
        VStack {
            Spacer()
            
            Text("Welcome To")
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color.gray60)
            
            IntroAnimationView {
                isAnimationComplete.toggle()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray5)
    }
    
    private var continueButton: some View {
        HStack {
            Text("Let's Go")
            
            Image(systemName: "checkmark")
        }
        .callToActionButton()
        .anyButton(.press) {
            onLetsGoButtonPressed()
        }
    }
    
    private func startLoading() async {
        do {
            let savingsPercentage = viewModel.savingsPercentage
            let roundedValue = savingsPercentage.rounded(.awayFromZero)
            let intValue: Int = Int(roundedValue)
            
            let result = try await authManager.createUser(withEmail: viewModel.email, password: viewModel.password)
            
            try await userManager.saveUser(
                auth: result,
                fullName: viewModel.fullName,
                monthlyIncome: viewModel.monthlyIncome,
                savingsPercentage: intValue,
                image: viewModel.profileImage
            )
            
            completeCircleAnimation()
            
            await showCircleSymbol()
            await showTryAgainButton()
            
            if !showFailLoading {
                try? await Task.sleep(for: .seconds(1))
                withAnimation(.snappy) {
                    isSpinnerComplete.toggle()
                    SoundsManager.instance.playPaymentSuccessSound()
                }
                
                try? await Task.sleep(for: .seconds(3))
                withAnimation(.bouncy) {
                    isCheckMarkComplete.toggle()
                }
            }
        } catch {
            errorMessage = error.localizedDescription
            showFailLoading = true
        }
    }
    
    private func completeCircleAnimation() {
        showLoading = true
        rotateLoading = 1.0
        showCircle = 1
    }
    
    private func showCircleSymbol() async {
        if showFailLoading {
            isXMarkPresented = true
        } else {
            isXMarkPresented = false
        }
        
        try? await Task.sleep(for: .seconds(0.5))
        rotateCheckMark = 0
        showCheckMark = 0
    }
    
    private func showTryAgainButton() async {
        if showFailLoading {
            SoundsManager.instance.playPaymentFailSound()
            
            try? await Task.sleep(for: .seconds(3))
            isTryAgainPresented = true
            showPopup = true
        }
    }
    
    private func onTryAgainButtonPressed() {
        router.navigateToSignUp()
    }
    
    private func onLetsGoButtonPressed() {
        appState.updateViewState(.onboarding)
    }
}

#Preview {
    ProfileSetupLoadingView(viewModel: .mock)
        .previewEnvironment()
}
