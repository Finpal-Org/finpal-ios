//
//  SwipeItem.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/6/25.
//

import SwiftUI

struct SwipeItem<Content: View, Left: View, Right: View>: View {
    var content: () -> Content
    var left: () -> Left
    var right: () -> Right
    var itemHeight: CGFloat
    
    init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder left: @escaping () -> Left,
        @ViewBuilder right: @escaping () -> Right,
        itemHeight: CGFloat
    ) {
        self.content = content
        self.left = left
        self.right = right
        self.itemHeight = itemHeight
    }
    
    @State private var hoffset: CGFloat = 0
    @State private var anchor: CGFloat = 0
    
    let screenWidth = UIScreen.main.bounds.width
    var anchorWidth: CGFloat { screenWidth / 3 }
    var swipeThreshold: CGFloat { screenWidth / 15 }
    
    @State private var rightPast: Bool = false
    @State private var leftPast: Bool = false
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation {
                    hoffset = anchor + value.translation.width
                    
                    if abs(hoffset) > anchorWidth {
                        if leftPast {
                            hoffset = anchorWidth
                        } else if rightPast {
                            hoffset = -anchorWidth
                        }
                    }
                    
                    if anchor > 0 {
                        leftPast = hoffset > anchorWidth - swipeThreshold
                    } else {
                        leftPast = hoffset > swipeThreshold
                    }
                    
                    if anchor < 0 {
                        rightPast = hoffset < -anchorWidth + swipeThreshold
                    } else {
                        rightPast = hoffset < -swipeThreshold
                    }
                }
            }
            .onEnded { value in
                withAnimation {
                    if rightPast {
                        anchor = -anchorWidth
                    } else if leftPast {
                        anchor = anchorWidth
                    } else {
                        anchor = 0
                    }
                    
                    hoffset = anchor
                }
            }
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                left()
                    .frame(width: anchorWidth)
                    .zIndex(1)
                    .clipped()
                
                content()
                    .frame(width: geometry.size.width)
                
                right()
                    .frame(width: anchorWidth)
                    .zIndex(1)
                    .clipped()
            }
            .offset(x: -anchorWidth + hoffset)
            .frame(maxHeight: itemHeight)
            .contentShape(Rectangle())
            .gesture(drag)
            .clipped()
        }
    }
}

private struct PreviewView: View {
    @State private var lineItem: LineItem = .mock
    
    var body: some View {
        VStack {
            SwipeItem(content: {
                LineItemRowView(lineItem: $lineItem)
            }, left: {
                ZStack {
                    
                }
            }, right: {
                ZStack {
                    Rectangle()
                        .fill(Color.red)
                    
                    Image(systemName: "trash.circle")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
            }, itemHeight: 50)
        }
    }
}

#Preview {
    PreviewView()
}
