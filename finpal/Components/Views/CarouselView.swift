//
//  CarouselView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/26/25.
//

import SwiftUI
import CarouselStack

struct CarouselView<Content: View>: View {
    @Binding var selectedIndex: Int
    
    @ViewBuilder var content: (Int) -> Content
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "righttriangle.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brand60)
                .rotationEffect(.degrees(45))
            
            CarouselStack(1...12) { index in
                content(index)
                    .scaledToFit()
                    .frame(width: selectedIndex == index ? 124 : 74, height: selectedIndex == index ? 124 : 74)
                    .padding(.horizontal, -12)
                    .overlay {
                            Circle()
                                .strokeBorder(Color.brand60, lineWidth: 4)
                                .frame(width: 128, height: 128)
                                .opacity(selectedIndex == index ? 1 : 0)
                                .transition(.opacity)
                    }
                    .onAppear {
                        selectedIndex = 1
                    }
            }
            .carouselStyle(.infiniteScroll)
            .onCarousel { context in
                selectedIndex = context.index + 1
            }
            
            Image(systemName: "righttriangle.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brand60)
                .rotationEffect(.degrees(225))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
        .animation(.bouncy.speed(7), value: selectedIndex)
    }
}

#Preview {
    @Previewable @State var selectedIndex: Int = 5
    
    CarouselView(selectedIndex: $selectedIndex) { index in
        Image("\(selectedIndex == index ? "Colored" : "Dark")Avatar_\(index)")
            .resizable()
    }
}
