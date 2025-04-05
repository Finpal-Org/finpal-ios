//
//  SavingsPercentageInputView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/24/25.
//

import SwiftUI

struct SavingsPercentageInputView: View {
    var size: CGSize
    
    @Binding var currentIndex: Int
    @Binding var sliderValue: Double
    
    var body: some View {
        VStack {
            Spacer()
            
            titleView
            
            Spacer()
        }
    }
    
    private var titleView: some View {
        VStack(spacing: 32) {
            Text("How much income do you save each month?")
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.horizontal, 24)
                .padding(.bottom)
                .addTitleAnimation(size: size, index: 2, currentIndex: currentIndex)
            
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
            .addSubtitleAnimation(size: size, index: 2, currentIndex: currentIndex)
            
            HStack {
                Text("Continue")
                
                Image(systemName: "arrow.right")
            }
            .callToActionButton()
            .anyButton(.press) {
                onContinueButtonPressed()
            }
            .padding()
            .addButtonAnimation(size: size, index: 2, currentIndex: currentIndex)
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
    
    private func onContinueButtonPressed() {
        currentIndex += 1
    }
}

#Preview {
    @Previewable @State var currentIndex: Int = 2
    
    GeometryReader { geometry in
        let size = geometry.size
        
        SavingsPercentageInputView(size: size, currentIndex: $currentIndex, sliderValue: .constant(25.0))
    }
}
