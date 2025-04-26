//
//  FilterCategoriesView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/26/25.
//

import SwiftUI

struct FilterCategoriesView: View {
    @Binding var selectedCategories: Set<CategoryModel>
    
    private let categories = CategoryModel.allCases
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(categories) { category in
                        FilterButtonView(
                            category: category,
                            isSelected: selectedCategories.contains(category),
                            onTap: onTap
                        )
                    }
                }
                .mediumShadow()
            }
            .scrollIndicators(.hidden)
        }
    }
    
    func onTap(category: CategoryModel) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}

struct FilterButtonView: View {
    var category: CategoryModel
    var isSelected: Bool
    var onTap: (CategoryModel) -> ()
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: category.iconName)
            
            Text(category.rawValue)
                .fixedSize(horizontal: true, vertical: true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            Capsule()
                .foregroundStyle(isSelected ? Color.brand60 : Color.white)
        }
        .frame(height: 40)
        .onTapGesture {
            withAnimation {
                onTap(category)
            }
        }
        .foregroundStyle(isSelected ? Color.white : Color.gray60)
    }
}

#Preview {
    @Previewable @State var selectedCategories = Set<CategoryModel>()
    
    ZStack {
        Color.gray5.ignoresSafeArea()
        
        FilterCategoriesView(selectedCategories: $selectedCategories)
    }
}
