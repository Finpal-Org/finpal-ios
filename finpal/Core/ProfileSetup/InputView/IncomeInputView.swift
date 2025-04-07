//
//  IncomeInputView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/24/25.
//

import SwiftUI

struct IncomeInputView: View {
    var size: CGSize
    
    @Binding var currentIndex: Int
    @Binding var monthlyIncome: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            titleView
            
            Spacer()
        }
    }
    
    private var titleView: some View {
        VStack(spacing: 64) {
            Text("How much money are you making monthly?")
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.horizontal, 24)
                .addTitleAnimation(size: size, index: 1, currentIndex: currentIndex)
            
            stepperView
                .addSubtitleAnimation(size: size, index: 1, currentIndex: currentIndex)
            
            HStack {
                Text("Continue")
                
                Image(systemName: "arrow.right")
            }
            .callToActionButton()
            .anyButton(.press) {
                onContinueButtonPressed()
            }
            .padding()
            .addButtonAnimation(size: size, index: 1, currentIndex: currentIndex)
        }
    }
    
    private var stepperView: some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Text("Monthly Amount")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.gray80)
                
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                        
                        Image(systemName: "minus")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(Color.gray80)
                    }
                    .frame(width: 48, height: 48)
                    .mediumShadow()
                    .anyButton(.press) {
                        onDecrementValuePressed()
                    }
                    
                    Spacer()
                    
                    Text("SAR \(monthlyIncome)")
                        .lineLimit(1)
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundStyle(Color.brand60)
                        .minimumScaleFactor(0.1)
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(Color.gray80)
                    }
                    .frame(width: 48, height: 48)
                    .mediumShadow()
                    .anyButton(.press) {
                        onIncrementValuePressed()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            }
            
            Text("Please enter your net income amount")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
        }
    }
    
    private func onIncrementValuePressed() {
        monthlyIncome += 50
    }
    
    private func onDecrementValuePressed() {
        if monthlyIncome > 50 {
            monthlyIncome -= 50
        }
    }
    
    private func onContinueButtonPressed() {
        currentIndex += 1
    }
}

#Preview {
    @Previewable @State var currentIndex: Int = 1
    @Previewable @State var monthlyIncome: Int = 10_000
    
    GeometryReader { geometry in
        let size = geometry.size
        
        IncomeInputView(size: size, currentIndex: $currentIndex, monthlyIncome: $monthlyIncome)
    }
}
