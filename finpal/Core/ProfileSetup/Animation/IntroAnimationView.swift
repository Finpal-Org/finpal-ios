//
//  IntroAnimationView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/27/25.
//

import SwiftUI

struct IntroAnimationView: View {
    let completion: () -> Void
    
    @State private var text: String = "finpal"
    @State private var circleOffset: CGFloat = 0
    @State private var textOffset: CGFloat = 0
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.gray5)
                    .overlay {
                        Image(.logoPlain)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .background(alignment: .leading) {
                                Capsule()
                                    .fill(Color.gray5)
                                    .frame(width: size.width)
                            }
                            .background(alignment: .leading) {
                                Text(text)
                                    .font(.system(size: 30, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.gray80)
                                    .frame(width: textSize(text))
                                    .offset(x: 10)
                                    .offset(x: textOffset)
                                    .mediumShadow()
                            }
                            .offset(x: -circleOffset)
                    }
            }
            .ignoresSafeArea()
        }
        .frame(height: 80)
        .task {
            let nanoSeconds = UInt64(1_000_000_000 * 0.5)
            try? await Task.sleep(nanoseconds: nanoSeconds)
            animate(0)
        }
    }
    
    private func animate(_ index: Int, _ loop: Bool = true) {
        withAnimation(.snappy(duration: 1), completionCriteria: .removed) {
            textOffset = -(textSize(text) + 20)
            circleOffset = -(textSize(text) + 20) / 2
        } completion: {
            completion()
        }
    }
    
    private func textSize(_ text: String) -> CGFloat {
        return NSString(string: text).size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle)]).width
    }
}

#Preview {
    IntroAnimationView {
        
    }
}
