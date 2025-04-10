//
//  HeaderAndChartView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/10/25.
//

import SwiftUI

struct HeaderAndChartView: View {
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
        VStack(alignment: .leading, spacing: 8) {
            Text("\(fullMonthNameFormatter.string(from: .now).uppercased()) SPENDING")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.brand50)
                .kerning(1.5)
            
            Text("SAR 0.00")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(Color.white)
            
            Text("- No data detected")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.white)
        }
        .padding(.horizontal, 16)
    }
}

private struct PreviewView: View {
    var body: some View {
        ScrollView {
            VStack {
                HeaderAndChartView()
                MostSpentCategoriesView()
                LatestReceiptsView()
                SpendingOverviewView()
            }
        }
        .background(Color.gray5)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    PreviewView()
}
