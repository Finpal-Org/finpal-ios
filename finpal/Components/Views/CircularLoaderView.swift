//
//  CircularLoaderView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/3/25.
//

import SwiftUI

struct CircularLoaderView: View {
    @State private var rotation: Double = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.3)
                .foregroundStyle(.gray)
            
            Circle()
                .trim(from: 0, to: 0.35)
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .foregroundStyle(Color.brand60)
                .rotationEffect(.degrees(rotation))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotation)
                .onAppear {
                    self.rotation = 360
                }
        }
        .compositingGroup()
        .frame(width: 64)
    }
}

#Preview {
    ZStack {
        Color.gray5
        
        VStack(spacing: 24) {
            CircularLoaderView()
            
            Text("Processing receipt...")
                .font(.title2)
                .fontWeight(.regular)
                .foregroundStyle(Color.gray80)
        }
        
    }
    .ignoresSafeArea()
}
