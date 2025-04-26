//
//  ReceiptsListView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/26/25.
//

import SwiftUI

struct ReceiptsListView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(ReceiptManager.self) private var receiptManager
    
    @State private var receipts: [ReceiptModel] = []
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if receipts.isEmpty {
                    Group {
                        if isLoading {
                            ProgressView()
                                .tint(Color.brand60)
                        } else {
                            
                        }
                    }
                    .padding(40)
                    .frame(maxWidth: .infinity)
                } else {
                    StaggeredView {
                        ForEach(receipts) { receipt in
                            CustomListCellView(
                                imageName: receipt.vendor?.logoURL,
                                title: receipt.vendor?.name,
                                subtitle: receipt.category,
                                dateText: receipt.dateText,
                                amount: receipt.total
                            )
                            .anyButton(.press) {
                                
                            }
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .task {
            await loadData()
        }
    }
    
    private func loadData() async {
        do {
            let uid = try authManager.getAuthId()
            receipts = try await receiptManager.getReceiptsForAuthor(userId: uid)
        } catch {
            
        }
        
        isLoading = false
    }
}

#Preview {
    ReceiptsListView()
        .previewEnvironment()
}
