//
//  GoalDifficultySliderView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/5/25.
//

import SwiftUI

struct GoalDifficultySliderView: View {
    @Binding var value: Double
    
    private let thumbRadius: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { proxy in
                let size = proxy.size
                
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray20)
                        .frame(width: size.width, height: 8)
                    
                    ZStack {
                        let valueChangeFraction = CGFloat(value / (0 - 1))
                        let tintedTrackWidth = size.width * valueChangeFraction
                        
                        let tintedTrackOffset = min((size.width / 2) + tintedTrackWidth, size.width / 2)
                        
                        Capsule()
                            .fill(Color.brand60)
                            .frame(width: abs(tintedTrackWidth), height: 8)
                            .offset(x: value)
                    }
                    
                    Circle()
                        .fill(Color.white)
                        .stroke(Color.brand60, lineWidth: 2)
                        .frame(width: thumbRadius * 2)
                        .offset(x: CGFloat(value) * size.width - thumbRadius)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged({ gesture in
                                    updateValue(with: gesture, in: proxy)
                                })
                        )
                }
            }
            .frame(height: 20)
            
            HStack {
                Text("Goal Difficulty")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.gray60)
                
                Spacer()
                
                Text("%\(String(format: "%.0f", value * 100))")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.gray60)
            }
        }
    }
    
    private func updateValue(with gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let newValue = gesture.location.x / geometry.size.width
        value = min(max(newValue, 0), 1)
    }
}

#Preview {
    GoalDifficultySliderView(value: .constant(0.5))
}
