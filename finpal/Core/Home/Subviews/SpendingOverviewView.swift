//
//  SpendingOverviewView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/10/25.
//

import SwiftUI

struct SpendingOverviewView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "lightbulb")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.gray60)
                
                Text("Spending Overview")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.gray80)
            }
            
            VStack {
                BarChartView()
            }
            .frame(height: 164)
            .padding(16)
            .background(Color.white, in: .rect(cornerRadius: 24))
            .mediumShadow()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .offset(x: 0, y: 20)
    }
}

extension Double {
    var trimmedDecimalString: String {
        self == self.rounded() ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
}

#Preview {
    ZStack {
        Color.gray5.ignoresSafeArea()
        
        SpendingOverviewView()
    }
}
