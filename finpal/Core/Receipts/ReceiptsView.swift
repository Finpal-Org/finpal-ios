//
//  ReceiptsView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/11/25.
//

import SwiftUI

struct ReceiptsView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(ReceiptManager.self) private var receiptManager
    
    @State private var myReceipts: [ReceiptModel] = []
    @State private var isLoading: Bool = true
    @State private var showView = false
    
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 24) {
            titleSection
            searchFieldSection
            sortOptionsSection
            myReceiptsSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
        .task {
            await loadData()
        }
        .onAppear {
            showView = true
        }
    }
    
    private func loadData() async {
        do {
            let uid = try authManager.getAuthId()
            myReceipts = try await receiptManager.getReceiptsForAuthor(userId: uid)
        } catch {
            print("[finpal - DEBUG] Failed to fetch user's receipts.")
        }
        
        isLoading = false
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Receipts")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Text("View your scanned receipts details here.")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
    }
    
    private var searchFieldSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TextField("", text: $searchText)
                    .placeholder(when: searchText.isEmpty) {
                        Text("Search receipts...")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(Color.gray60)
                    }
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .foregroundStyle(Color.gray80)
                    .padding([.leading, .trailing], 12)
                    .autocorrectionDisabled()
                    .truncationMode(.tail)
                    .background(Color.clear)
                
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.gray60)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 12)
            }
            .background {
                Capsule()
                    .stroke(Color.gray30, lineWidth: 1)
                    .background(Color.white, in: .capsule)
            }
            .padding(.horizontal, 14)
        }
    }
    
    private var sortOptionsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("All Receipts")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.gray80)
                
                Spacer()
                
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.brand60)
                    
                    Text("Sort By: Date")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.gray80)
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(Color.gray60)
                        .fontWeight(.semibold)
                }
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "archivebox")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.gray60)
                            .fontWeight(.semibold)
                        
                        Text("All")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.gray60)
                    }
                    .frame(height: 40)
                    .padding(.horizontal, 16)
                    .background(Color.white, in: .capsule)
                    .mediumShadow()
                    
                    ForEach(CategoryModel.allCases, id: \.self) { category in
                        HStack(spacing: 8) {
                            Image(systemName: category.iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.gray60)
                                .fontWeight(.semibold)
                            
                            Text(category.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.gray60)
                        }
                        .frame(height: 40)
                        .padding(.horizontal, 16)
                        .background(Color.white, in: .capsule)
                        .mediumShadow()
                    }
                }
            }
            .scrollIndicators(.hidden)
            
        }
        .padding(.horizontal, 14)
    }
    
    private var myReceiptsSection: some View {
        ZStack {
            if myReceipts.isEmpty {
                Group {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Click to add receipts")
                    }
                }
                .padding(40)
                .frame(maxWidth: .infinity)
            } else {
                ReceiptsRowView(showView: $showView, receipts: $myReceipts)
            }
        }
    }
    
}

#Preview {
    ReceiptsView()
        .previewEnvironment()
}
