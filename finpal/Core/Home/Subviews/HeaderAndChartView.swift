//
//  HeaderAndChartView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/10/25.
//

import SwiftUI

struct HeaderAndChartView: View {
    let spending: [Double]
    let percentChange: Double
    
    let weekdayDayMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM"
        return formatter
    }()
    
    let fullMonthNameFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"  // Full month name
        return formatter
    }()
    
    var totalSpending: Double {
        spending.reduce(0, +)
    }
    
    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .global).minY
            let isScrolling = minY > 0
            
            ZStack {
                Color.brand60
                    .frame(height: isScrolling ? 412 + minY : 412)
                    .clipped()
                    .offset(y: isScrolling ? -minY : 0)
                
                VStack(alignment: .leading) {
                    navigationBar
                    
                    Spacer()
                    
                    monthSpending
                    
                    Spacer()
                    
                    Text("")
                    
                    Spacer()
                }
            }
        }
        .frame(height: 412)
    }
    
    private var navigationBar: some View {
        HStack {
            Spacer()
            
            Text(weekdayDayMonthFormatter.string(from: .now))
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.white)
            
            Spacer()
        }
        .padding(.top, 60)
    }
    
    private var monthSpending: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(fullMonthNameFormatter.string(from: .now).uppercased()) SPENDING")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.brand40)
                    .kerning(1.5)
                
                Text(totalSpending, format: .currency(code: "SAR"))
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Color.white)
                
                percentageChangeView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            LineGraphView(spending: spending)
        }
    }
    
    private var percentageChangeView: some View {
        Group {
            if totalSpending == 0.0 {
                HStack(spacing: 4) {
                    Image(systemName: "minus")
                    
                    Text("No data detected")
                }
            } else {
                HStack(spacing: 4) {
                    if percentChange < 0 {
                        Image(systemName: "arrow.down")
                    } else {
                        Image(systemName: "arrow.up")
                    }
                    
                    Text(String(format: "%.1f%%", percentChange))
                    
                    Text("vs last month")
                }
            }
        }
        .font(.system(size: 14, weight: .bold))
        .foregroundStyle(Color.white)
    }
    
}

private struct PreviewView: View {
    var body: some View {
        ScrollView {
            VStack {
                HeaderAndChartView(
                    spending: [0, 34, 23, 2.43, 54, 3.2, 80],
                    percentChange: 32.4
                )
            }
        }
        .background(Color.gray5)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    PreviewView()
}
