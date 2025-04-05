//
//  CategorySheetView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/2/25.
//

import SwiftUI

struct CategorySheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var category: CategoryModel?
    
    @State private var selectedCategory: CategoryModel?
    @State private var showingError: Bool = false
    
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
            .padding(.horizontal)
            
            // Categories
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: -16), count: 3),
                spacing: 18,
                content: {
                    ForEach(CategoryModel.allCases, id: \.self) { category in
                        CategoryCell(category: category, selectedCategory: $selectedCategory)
                            .onTapGesture {
                                onCategoryPressed(category: category)
                            }
                    }
                }
            )
            .padding(.horizontal, 8)
            
            // Button
            selectButton
        }
        .errorPopup(showingPopup: $showingError, "Select a category before proceeding.")
        .onAppear {
            selectedCategory = category
        }
    }
    
    private var selectButton: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Select")
                
                Image(systemName: "checkmark")
            }
            .callToActionButton()
            .anyButton(.press) {
                onSelectButtonPressed()
            }
        }
        .padding(.horizontal)
        .animation(.easeInOut, value: showingError)
    }
    
    private func onSelectButtonPressed() {
        if let selectedCategory {
            category = selectedCategory
            dismiss()
        } else {
            showingError = true
        }
    }
    
    private func onXMarkButtonPressed() {
        dismiss()
    }
    
    private func onCategoryPressed(category: CategoryModel) {
        withAnimation(.easeInOut) {
            if selectedCategory != nil && selectedCategory == category {
                selectedCategory = nil
            } else {
                selectedCategory = category
                showingError = false
            }
        }
    }
}

private struct CategoryCell: View {
    let category: CategoryModel
    
    @Binding var selectedCategory: CategoryModel?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray10)
                .frame(width: 100, height: 100)
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
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .padding(4)
            }
        }
    }
}

private struct PreviewView: View {
    @State private var selectedCategory: CategoryModel? = .transportation
    
    var body: some View {
        ZStack {
            Color.gray5.ignoresSafeArea()
            
            CategorySheetView(category: $selectedCategory)
        }
    }
}

#Preview {
    PreviewView()
}
