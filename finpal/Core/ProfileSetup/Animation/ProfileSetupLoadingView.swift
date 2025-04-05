//
//  ProfileSetupLoadingView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/27/25.
//

import SwiftUI
import ConfettiSwiftUI

struct ProfileSetupLoadingView: View {
    @Namespace private var animation
    
    @State private var showCircle: Int = 0
    @State private var rotateCheckMark: Int = 30
    @State private var showCheckMark: Int = -60
    
    @State private var showLoading: Bool = false
    @State private var rotateLoading: Double = 0.35
    
    @State private var isSpinnerComplete: Bool = false
    @State private var isCheckMarkComplete: Bool = false
    @State private var isAnimationComplete: Bool = false
    
    var body: some View {
        VStack(spacing: 32) {
            if isCheckMarkComplete {
                animationView
                    .matchedGeometryEffect(id: "Setup", in: animation)
            } else {
                loadingView
                    .matchedGeometryEffect(id: "Setup", in: animation)
            }
        }
    }
    
    private var circleAnimation: some View {
        ZStack {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundStyle(Color.brand60)
                .scaleEffect(CGFloat(showCircle))
                .animation(.interpolatingSpring(stiffness: 170, damping: 15).delay(0.5), value: showCircle)
            
            Image(systemName: "checkmark")
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
                    .foregroundStyle(Color.brand60)
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
                    Text("Creating a personalized financial experience...")
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
                .onTapGesture {
                    isAnimationComplete.toggle()
                }
            
            IntroAnimationView {
                isAnimationComplete.toggle()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray5)
        .safeAreaInset(edge: .bottom, alignment: .center, spacing: 16) {
            ZStack {
                if isAnimationComplete {
                    continueButton
                        .transition(.move(edge: .bottom))
                }
            }
            .padding()
        }
        .animation(.bouncy, value: isAnimationComplete)
    }
    
    private var continueButton: some View {
        NavigationLink {
            
        } label: {
            HStack {
                Text("Complete")
                
                Image(systemName: "checkmark")
            }
            .callToActionButton()
        }
    }
    
    private func startLoading() async {
        try? await Task.sleep(for: .seconds(5))
        showLoading = true
        rotateLoading = 1.0
        showCircle = 1
        rotateCheckMark = 0
        showCheckMark = 0
        
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

#Preview {
    ProfileSetupLoadingView()
}
