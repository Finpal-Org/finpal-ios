//
//  ProgressViewModifier.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/28/25.
//

import SwiftUI

struct FinpalProgressViewStyle: ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .accentColor(Color.brand60)
            .frame(height: 8.0)
            .scaleEffect(x: 1, y: 2, anchor: .center)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .padding(.horizontal)
    }
}

extension View {
    
    func finpalProgressBar() -> some View {
        progressViewStyle(FinpalProgressViewStyle())
    }
}
