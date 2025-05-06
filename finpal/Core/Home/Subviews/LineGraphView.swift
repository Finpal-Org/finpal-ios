//
//  LineGraphView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/4/25.
//

import SwiftUI
import SwiftUICharts

struct LineGraphView: View {
    let spending: [Double]
    
    var body: some View {
        VStack {
            LineChart()
                .data(spending)
                .chartStyle(
                    ChartStyle(
                        backgroundColor: Color.brand60,
                        foregroundColor: [
                            ColorGradient(Color.white),
                            ColorGradient(Color.brand20),
                        ]
                    )
                )
                .frame(height: 100)
        }
        .padding(.bottom, 24)
    }
}

#Preview {
    LineGraphView(spending: [0, 25, 30])
}
