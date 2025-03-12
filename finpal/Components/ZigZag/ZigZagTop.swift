//
//  ZigZagTop.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/3/25.
//

import SwiftUI

struct ZigZagTop: Shape {
    var depth: CGFloat
    
    var animatableData: CGFloat {
        get { depth }
        set { depth = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        // Draw the top border with zigzag or straight line if depth is 0
        if depth == 0 {
            p.move(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        } else {
            p.move(to: CGPoint(x: rect.minX, y: rect.minY))
            drawZigZag(path: &p, from: CGPoint(x: rect.minX, y: rect.minY), to: CGPoint(x: rect.maxX, y: rect.minY), height: depth)
        }
        
        // Draw the right border
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        // Draw the bottom border
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // Draw the left border
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        p.closeSubpath()
        
        return p
    }
    
    private func drawZigZag(path: inout Path, from start: CGPoint, to end: CGPoint, height: CGFloat) {
        let length = end.x - start.x
        let numberOfZigzags = Int(length / (height * 2))
        let zigzagLength = length / CGFloat(numberOfZigzags * 2)
        
        for i in 0..<numberOfZigzags {
            let offset = CGFloat(i * 2)
            let point1 = CGPoint(x: start.x + offset * zigzagLength, y: start.y)
            let point2 = CGPoint(x: start.x + (offset + 1) * zigzagLength, y: start.y + height)
            let point3 = CGPoint(x: start.x + (offset + 2) * zigzagLength, y: start.y)
            
            path.addLine(to: point1)
            path.addLine(to: point2)
            path.addLine(to: point3)
        }
        
        path.addLine(to: end)
    }
    
}

#Preview("Top") {
    VStack {
        Spacer()
        
        ZigZagTop(depth: 8)
            .fill(.red)
            .frame(width: .infinity, height: 200)
    }
    .ignoresSafeArea()
}
