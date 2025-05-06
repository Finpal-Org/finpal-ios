//
//  DotsAnimation.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/27/25.
//

import SwiftUI

struct DotsAnimation: View {
    
    struct AnimationData {
        var delay: TimeInterval
        var ty: CGFloat
    }
    
    static let DATA = [
        AnimationData(delay: 0.0, ty: -5),
        AnimationData(delay: 0.1, ty: -10),
        AnimationData(delay: 0.2, ty: -15),
    ]
    
    @State var color: Color
    @State var transY: [CGFloat] = DATA.map { _ in return 0 }
    
    var animation = Animation.easeInOut.speed(0.6)
    
    init(color: Color) {
        self.color = color
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ZStack {
                Circle()
                    .foregroundStyle(.white)
                
                Image(.finpalChatbotRobot)
                    .font(.system(size: 20))
            }
            .frame(width: 40, height: 40)
            .clipShape(.circle)
            
            HStack {
                DotView(color: .constant(color), transY: $transY[0])
                DotView(color: .constant(color), transY: $transY[1])
                DotView(color: .constant(color), transY: $transY[2])
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray20, lineWidth: 1)
                    .background(Color.white, in: .rect(cornerRadius: 16))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.trailing, 75)
        .onAppear {
            animateDots()
        }
    }
    
    func animateDots() {
        for (index, data) in Self.DATA.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + data.delay) {
                animateDot(binding: $transY[index], animationData: data)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            animateDots()
        }
    }
    
    func animateDot(binding: Binding<CGFloat>, animationData: AnimationData) {
        withAnimation(animation) {
            binding.wrappedValue = animationData.ty
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(animation) {
                binding.wrappedValue = 0
            }
        }
    }
}

private struct DotView: View {
    
    @Binding var color: Color
    @Binding var transY: CGFloat
    
    var body: some View {
        VStack{ }
            .frame(width: 8, height: 8, alignment: .center)
            .background(color)
            .cornerRadius(20.0)
            .offset(x: 0, y: transY)
    }
}

#Preview {
    DotsAnimation(color: Color.gray60)
}
