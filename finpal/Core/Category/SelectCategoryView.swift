//
//  SelectCategoryView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/2/25.
//

import SwiftUI

struct SelectCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedCategory: Category
    
    var body: some View {
        VStack(spacing: 32) {
            
            // Title
            HStack {
                Text("Select Category")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.gray80)
                
                Spacer()
                
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.gray60)
                    .onTapGesture {
                        onXMarkButtonPressed()
                    }
            }
            
            // Categories
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 4),
                spacing: 8,
                content: {
                    ForEach(Category.allCases, id: \.id) { category in
                        CategoryCell(category: category, selectedCategory: $selectedCategory)
                            .onTapGesture {
                                onCategoryPressed(category: category)
                            }
                    }
                }
            )
            .padding(.horizontal, 8)
            
            // Button
            HStack {
                Text("Select")
                
                Image(systemName: "checkmark")
            }
            .callToActionButton()
            .anyButton(.press) {
                onSelectButtonPressed()
            }
            
        }
        .padding()
    }
    
    private func onSelectButtonPressed() {
        dismiss()
    }
    
    private func onXMarkButtonPressed() {
        dismiss()
    }
    
    private func onCategoryPressed(category: Category) {
        withAnimation(.easeInOut) {
            selectedCategory = category
        }
    }
}

private struct CategoryCell: View {
    let category: Category
    
    @Binding var selectedCategory: Category
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray10)
                .frame(width: 80, height: 84)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(selectedCategory == category ? Color.brand60 : Color.clear, lineWidth: 2)
                        .fill(selectedCategory == category ? Color.brand5 : Color.clear)
                }
            
            VStack(spacing: 8) {
                Image(systemName: category.iconName)
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(selectedCategory == category ? Color.brand60 : Color.gray80)
                
                Text(category.rawValue)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
        }
    }
}

private struct PreviewView: View {
    @State private var selectedCategory: Category = .transport
    
    var body: some View {
        ZStack {
            Color.gray5.ignoresSafeArea()
            
            SelectCategoryView(selectedCategory: $selectedCategory)
        }
    }
}

#Preview {
    PreviewView()
}
