//
//  GoalDifficultyView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/5/25.
//

import SwiftUI

enum GoalDifficulty: String, CaseIterable {
    case easy = "Easy"
    case moderate = "Moderate"
    case challenging = "Challenging"
}

extension GoalDifficulty {
    
    init(fromPercentage value: Double) {
        switch value {
        case 0..<0.4:
            self = .easy
        case 0.4..<0.7:
            self = .moderate
        default:
            self = .challenging
        }
    }
}

struct GoalDifficultyView: View {
    @Binding var page: Int
    @Binding var sliderValue: Double
    
    @State private var difficulty: GoalDifficulty = .moderate
    
    var body: some View {
        VStack {
            Text("On the scale to 1 - 100, how difficult is it to achieve this \ngoal?")
                .multilineTextAlignment(.leading)
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color.gray80)
                .tracking(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack {
                Text(difficulty.rawValue)
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundStyle(Color.brand60)
                
                GoalDifficultySliderView(value: $sliderValue)
            }
            .onChange(of: sliderValue) { oldValue, newValue in
                difficulty = GoalDifficulty(fromPercentage: sliderValue)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12) {
                HStack {
                    Text("Continue")
                    
                    Image(systemName: "arrow.right")
                }
                .callToActionButton()
                .frame(width: 142)
                .anyButton(.press) {
                    page += 1
                }
                
                HStack {
                    Image(systemName: "chevron.left")
                    
                    Text("No, Go Back")
                }
                .secondaryButton()
                .frame(width: 162)
                .anyButton(.press) {
                    page -= 1
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    @Previewable @State var difficultyValue = 0.5
    GoalDifficultyView(page: .constant(4), sliderValue: $difficultyValue)
}
