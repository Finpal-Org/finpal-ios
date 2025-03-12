//
//  ReceiptView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/3/25.
//

import SwiftUI
import MapKit

//RoundedRectangle(cornerRadius: 16)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 500)
//                        .foregroundStyle(Color.white)
//                        .padding()
//                        .overlay {
//                            VStack(spacing: 20) {
//
//                                CategoryDropdownView(selectedCategory: $selectedCategory, isExpanded: $isExpanded)
//                                paymentMethodSection
//                                addressSection
//                            }
//                            .padding()
//                        }

struct ReceiptView: View {
    @State var receiptData: ReceiptData
    @State private var showError: Bool = false
    
    @State private var selectedCategory: Category = .other
    @State private var isCategorySheetPresented: Bool = false
    
    var body: some View {
        VStack {
            receiptDetailsToolbar
            
            ScrollView {
                // Receipt Details
                ReceiptDataView(data: receiptData)
                
                categorySelectionView
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
        .sheet(isPresented: $isCategorySheetPresented) {
            SelectCategoryView(selectedCategory: $selectedCategory)
                .presentationDetents([.fraction(0.65)])
                .presentationDragIndicator(.visible)
        }
    }
    
    private var receiptDetailsToolbar: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "gearshape")
            }
        }
        .font(.system(size: 20, weight: .medium))
        .overlay {
            Text("Scanned Receipt")
                .font(.system(size: 16, weight: .semibold))
        }
        .foregroundStyle(Color.gray80)
        .padding(16)
    }
    
    private var categorySelectionView: some View {
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
                        
                        Image(systemName: selectedCategory.iconName)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    
                    // Category Text
                    Text("Category")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                    
                    Spacer()
                    
                    // Selected Category
                    Text(selectedCategory.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.gray80)
                    
                    // Chevron
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.gray60)
                }
                .padding()
            }
            .padding()
            .mediumShadow()
            .onTapGesture {
                onCategoryButtonPressed()
            }
    }
    
    private var noteButtonView: some View {
        RoundedRectangle(cornerRadius: 16)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .foregroundStyle(Color.white)
            .overlay {
                HStack(spacing: 8) {
                    // Note Icon
                    ZStack {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(Color.gray5)
                        
                        Image(systemName: "note.text")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    
                    // Note Title
                    Text("Note")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                    
                    Spacer()
                    
                    // Selected Category
                    Text(selectedCategory.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.gray80)
                    
                    // Chevron
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.gray60)
                }
                .padding()
            }
            .padding()
            .mediumShadow()
            .onTapGesture {
                onCategoryButtonPressed()
            }
    }
    
    private var paymentMethodSection: some View {
        VStack(alignment: .leading) {
            Text("Payment Method")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            HStack(spacing: 16) {
                Image(.mastercardLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 58, height: 40)
                
                VStack(alignment: .leading) {
                    Text("Mastercard")
                    
                    Text("5566 8990 XXXX XXXX")
                }
                .font(.caption)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var addressSection: some View {
        VStack(alignment: .leading) {
            Text("Address")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Map()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.horizontal)
    }
    
    private func onCategoryButtonPressed() {
        isCategorySheetPresented = true
    }
}

private struct PreviewView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray5.ignoresSafeArea()
                
                ReceiptView(receiptData: .mock)
            }
            .toolbar(.hidden)
        }
    }
}

#Preview {
    PreviewView()
}
