//
//  MostSpentCategoriesView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/10/25.
//

import SwiftUI

struct MostSpentCategoriesView: View {
    var body: some View {
        VStack {
            
            ForEach(Array(UserCategorySpending.mocks.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: 14) {
                    categoryRow(category: item.category, amount: item.amount)
                        .padding(.vertical, 8)
                    
                    if index < UserCategorySpending.mocks.count - 1 {
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
        .offset(x: 0, y: -50)
        .mediumShadow()
    }
    
    private func categoryRow(category: CategoryModel, amount: Double) -> some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.brand60)
                    
                    Image(systemName: category.iconName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 14, height: 14)
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
}

#Preview {
    MostSpentCategoriesView()
}
