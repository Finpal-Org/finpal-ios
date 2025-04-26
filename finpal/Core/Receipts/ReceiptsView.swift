//
//  ReceiptsView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/11/25.
//

import SwiftUI

struct ReceiptsView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(ReceiptManager.self) private var receiptManager
    
    @State private var viewModel = ReceiptsViewModel()
    
    @State private var myReceipts: [ReceiptModel] = []
    @State private var isLoading = true
    
    @State private var searchText = ""
    
    @State private var path: [NavigationPathOption] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 24) {
                titleSection
                searchFieldSection
                sortOptionsSection
                myReceiptsSection
            }
            .navigationDestinationForCoreModule(path: $path)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.gray5)
            .task {
                await loadData()
            }
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
                
                SelectSortOrderView(sortType: $viewModel.sortType)
            }
            
            FilterCategoriesView(selectedCategories: $viewModel.selectedCategories)
        }
        .padding(.horizontal, 14)
    }
    
    private var noReceiptsFound: some View {
        VStack(spacing: 24) {
            Image(systemName: "receipt")
                .font(.system(size: 48))
                .foregroundStyle(Color.gray40)
            
            VStack(spacing: 12) {
                Text("No receipts found")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                
                Text("It looks like you don’t have any receipts. Once you add one, it will appear here.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.gray60)
            }
        }
    }
    
    private var myReceiptsSection: some View {
        ScrollView {
            LazyVStack {
                if myReceipts.isEmpty {
                    Group {
                        if isLoading {
                            ProgressView()
                                .tint(Color.brand60)
                        } else {
                            noReceiptsFound
                        }
                    }
                    .padding(40)
                    .frame(maxWidth: .infinity)
                } else {
                    StaggeredView {
                        ForEach(viewModel.sortedReceipts(myReceipts: myReceipts)) { receipt in
                            CustomListCellView(
                                imageName: receipt.vendor?.logoURL,
                                title: receipt.vendor?.name,
                                subtitle: receipt.category,
                                dateText: receipt.dateText,
                                amount: receipt.total
                            )
                            .anyButton(.press) {
                                onReceiptPressed(receipt: receipt)
                            }
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private func onReceiptPressed(receipt: ReceiptModel) {
        path.append(.receipt(receipt: receipt))
    }
}

#Preview {
    ReceiptsView()
        .previewEnvironment()
}
