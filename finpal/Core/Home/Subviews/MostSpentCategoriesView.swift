//
//  MostSpentCategoriesView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/10/25.
//

import SwiftUI

struct TopCategory: Identifiable {
    let id = UUID()
    let category: CategoryModel
    let total: Double
    
    static var mocks: [Self] {
        [
            TopCategory(category: .entertainment, total: 34.22),
            TopCategory(category: .meal, total: 23.12),
            TopCategory(category: .supplies, total: 88.32),
            TopCategory(category: .fuel, total: 50.0),
            TopCategory(category: .transportation, total: 10.0),
        ]
    }
}

struct MostSpentCategoriesView: View {
    let topCategories: [TopCategory]
    
    var body: some View {
        VStack {
            ForEach(Array(topCategories.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: 14) {
                    categoryRow(category: item.category, amount: item.total, index: index)
                        .padding(8)
                    
                    if index < topCategories.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 24))
        .padding(.horizontal, 16)
        .offset(x: 0, y: -85)
        .mediumShadow()
    }
    
    private func categoryRow(category: CategoryModel, amount: Double, index: Int) -> some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(colorForIndex(index))
                    
                    Image(systemName: category.iconName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.white)
                    
                }
                
                Text(category.rawValue)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.gray60)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("SAR \(formatCurrency(amount))")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.gray80)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 9, height: 9)
                    .foregroundStyle(Color.gray60)
                    .padding(.top, 3)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    private func colorForIndex(_ index: Int) -> Color {
        switch index {
        case 0:
            return Color.brand60
        case 1:
            return Color.warning30
        case 2:
            return Color.destructive50
        case 3:
            return Color.gray60
        case 4:
            return Color.blue50
        default:
            return Color.brand60
        }
    }
}

#Preview {
    MostSpentCategoriesView(topCategories: TopCategory.mocks)
}
