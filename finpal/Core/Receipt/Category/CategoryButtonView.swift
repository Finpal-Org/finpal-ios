//
//  CategoryButtonView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/19/25.
//

import SwiftUI

struct CategoryButtonView: View {
    @Binding var selectedCategory: CategoryModel?
    
    @State private var isCategorySheetPresented: Bool = false
    
    var body: some View {
        Button {
            isCategorySheetPresented = true
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .foregroundStyle(Color.white)
                .overlay {
                    HStack(spacing: 8) {
                        // Category Icon
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color.gray5)
                            
                            Image(systemName: selectedCategory?.iconName ?? "questionmark")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.gray60)
                        }
                        
                        // Category Text
                        Text("Category")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.gray80)
                        
                        Spacer()
                        
                        // Selected Category
                        Text(selectedCategory?.rawValue ?? "Not Set")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.gray80)
                        
                        // Chevron
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    .padding()
                }
                .padding(.horizontal)
        }
        .mediumShadow()
        .sheet(isPresented: $isCategorySheetPresented) {
            CategorySheetView(category: $selectedCategory)
                .presentationDetents([.fraction(0.95)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    @Previewable @State var selectedCategory: CategoryModel?
    
    CategoryButtonView(selectedCategory: $selectedCategory)
}
