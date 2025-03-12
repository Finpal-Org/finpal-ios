//
//  CategoryDropdownView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/3/25.
//

import SwiftUI

struct CategoryDropdownView: View {
    @Binding var selectedCategory: Category
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Category")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Capsule()
                .stroke(Color.gray30, lineWidth: 1)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.white)
                .overlay {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 38, height: 38)
                                .foregroundStyle(Color.gray10)
                            
                            Image(systemName: selectedCategory.iconName)
                                .foregroundStyle(Color.gray60)
                                .imageScale(.medium)
                        }
                        
                        Text(selectedCategory.rawValue)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.gray60)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color.gray60)
                            .imageScale(.large)
                    }
                    .padding()
                }
                .onTapGesture {
                    isExpanded.toggle()
                }
        }
        .padding(.horizontal)
        .sheet(isPresented: $isExpanded) {
            SelectCategoryView(selectedCategory: $selectedCategory)
                .presentationDetents([.fraction(0.65)])
                .presentationDragIndicator(.visible)
        }
    }
}

private struct PreviewView: View {
    @State private var selectedCategory: Category = .rent
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ZStack {
            Color.gray5.ignoresSafeArea()
            
            CategoryDropdownView(selectedCategory: $selectedCategory, isExpanded: $isExpanded)
        }
    }
}

#Preview {
    PreviewView()
}
