//
//  SavingsPercentageInputView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/24/25.
//

import SwiftUI

struct SavingsPercentageInputView: View {
    @State private var sliderValue: Double = 25
    
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
        VStack(spacing: 32) {
            Text("How much income do you save each month?")
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.horizontal, 24)
                .padding(.bottom)
            
            VStack(spacing: 24) {
                circularSliderView
                
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(Color.gray60)
                    
                    Text("Drag the chart to adjust")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.gray60)
                }
                .padding(.top)
                
                (
                    Text("I'd like to save ")
                    +
                    Text(sliderValue, format: .number.rounded(increment: 1.0))
                        .bold()
                    +
                    Text("%")
                        .bold()
                    +
                    Text(" of my income")
                )
                .font(.system(size: 18, weight: .regular))
            }
            
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
    
    private var circularSliderView: some View {
        CircularSlider(
            currentValue: $sliderValue,
            knobRadius: 18,
            radius: 150,
            progressLineColor: Color.brand60,
            trackColor: Color.gray20,
            lineWidth: 24,
            font: .system(size: 60, weight: .bold),
            textColor: Color.gray80
        )
    }
}

#Preview {
    SavingsPercentageInputView()
}
