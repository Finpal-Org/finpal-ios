//
//  IncomeInputView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/24/25.
//

import SwiftUI

struct IncomeInputView: View {
    @State private var monthlyIncome: Int = 1000
    
    var body: some View {
        VStack {
            toolbarView
            
            Spacer()
            
            titleView
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
    }
    
    private var toolbarView: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray80)
            
            ProgressView(value: 0.8)
                .progressViewStyle(FinpalProgressViewStyle())
            
            Text("Skip")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.brand60)
                .anyButton {
                    
                }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private var titleView: some View {
        VStack(spacing: 64) {
            Text("How much money are you making monthly?")
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.horizontal, 24)
            
            stepperView
            
            HStack {
                Text("Continue")
                
                Image(systemName: "arrow.right")
            }
            .callToActionButton()
            .anyButton(.press) {
                
            }
            .padding()
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
    
}

#Preview {
    IncomeInputView()
}
