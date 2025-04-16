//
//  ReceiptsRowView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/16/25.
//

import SwiftUI

struct ReceiptsRowView: View {
    @Binding var showView: Bool
    @Binding var receipts: [ReceiptModel]
    
    @Namespace private var animation
    
    @State private var isExpanded = false
    @State private var expandedReceipt: ReceiptModel?
    @State private var loadExpandedContent = false
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 8) {
                StaggeredView {
                    if showView {
                        ForEach(receipts) { receipt in
                            rowView(receipt: receipt)
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            Rectangle()
                .fill(Color.black)
                .opacity(loadExpandedContent ? 1 : 0)
                .opacity(offsetProgress())
                .ignoresSafeArea()
        }
        .overlay {
            if let expandedReceipt, isExpanded {
                expandedView(receipt: expandedReceipt)
            }
        }
    }
    
    private func offsetProgress() -> CGFloat {
        let progress = offset.height / 100
        
        if offset.height < 0 {
            return 1
        } else {
            return 1 - (progress < 1 ? progress : 1)
        }
    }
    
    private func expandedView(receipt: ReceiptModel) -> some View {
        VStack {
            GeometryReader { proxy in
                let size = proxy.size
                
                ZStack {
                    vendorLogoView(receipt: receipt)
                }
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: loadExpandedContent ? 0 : size.height))
                .offset(y: loadExpandedContent ? offset.height : .zero)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { value in
                            let height = value.translation.height
                            if height > 0 && height > 100 {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    loadExpandedContent = false
                                }
                                
                                withAnimation(.easeInOut(duration: 0.4).delay(0.05)) {
                                    isExpanded = false
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    offset = .zero
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    offset = .zero
                                }
                            }
                        }
                )
            }
            .matchedGeometryEffect(id: receipt.receiptId, in: animation)
            .frame(height: 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top) {
            navigationBarView(receipt: receipt)
                .padding()
                .opacity(loadExpandedContent ? 1 : 0)
                .opacity(offsetProgress())
        }
        .transition(.offset(x: 0, y: 1))
        .onAppear {
            withAnimation(.easeInOut(duration: 0.4)) {
                loadExpandedContent = true
            }
        }
    }
    
    @ViewBuilder
    private func vendorLogoView(receipt: ReceiptModel) -> some View {
        if let vendor = receipt.vendor {
            
            if let vendorLogo = vendor.logoURL {
                ImageLoaderView(urlString: vendorLogo)
                    .aspectRatio(contentMode: .fill)
            } else {
                // Placeholder
            }
            
        } else {
            // Placeholder
        }
    }
    
    private func navigationBarView(receipt: ReceiptModel) -> some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.white)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        loadExpandedContent = false
                    }
                    
                    withAnimation(.easeInOut(duration: 0.4).delay(0.05)) {
                        isExpanded = false
                    }
                }
            
            Text(receipt.vendor?.name ?? "")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
            
            Spacer()
        }
    }
    
    private func rowView(receipt: ReceiptModel) -> some View {
        HStack(spacing: 16) {
            
            if let vendor = receipt.vendor {
                HStack(spacing: 12) {
                    // Image
                    if let vendorLogo = vendor.logoURL {
                        
                        VStack {
                            if expandedReceipt?.receiptId == receipt.receiptId && isExpanded {
                                ImageLoaderView(urlString: vendorLogo)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 48, height: 48)
                                    .clipShape(.rect(cornerRadius: 0))
                                    .opacity(0)
                            } else {
                                ImageLoaderView(urlString: vendorLogo)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 48, height: 48)
                                    .clipShape(.circle)
                                    .matchedGeometryEffect(id: receipt.receiptId, in: animation)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                isExpanded = true
                                expandedReceipt = receipt
                            }
                        }
                        
                    } else {
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        // Vendor Name
                        Text(vendor.name ?? "")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.gray80)
                        
                        // Note (if nil show Category)
                        Label(receipt.categoryEnum.rawValue, systemImage: receipt.categoryEnum.iconName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.gray80)
                        
                        // Date
                        Text(receipt.dateText)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.gray60)
                    }
                }
            } else {
                // Placeholder
            }
            
            Spacer()
            
            // Total
            Text("SAR \(receipt.total ?? 0.0, specifier: "%.2f")")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 90)
        .padding(.horizontal, 12)
        .background(Color.white, in: .rect(cornerRadius: 20))
        .padding(.horizontal, 16)
        .mediumShadow()
    }
    
}

#Preview {
    @Previewable @State var showView = false
    ReceiptsRowView(showView: $showView, receipts: .constant(ReceiptModel.mocks))
}
