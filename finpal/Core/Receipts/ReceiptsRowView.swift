//
//  ReceiptsRowView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/16/25.
//

import SwiftUI

struct ReceiptsRowView: View {
    let receipt: ReceiptModel
    
    var body: some View {
        HStack(spacing: 16) {
            
            if let vendor = receipt.vendor {
                HStack(spacing: 12) {
                    // Image
                    if let vendorLogo = vendor.logoURL {
                        ImageLoaderView(urlString: vendorLogo)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 48, height: 48)
                            .clipShape(.circle)
                    } else {
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        // Vendor Name
                        Text(vendor.name ?? "")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.gray80)
                        
                        // Note (if nil show Category)
                        Label(receipt.category.rawValue, systemImage: receipt.category.iconName)
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
            Text("SAR \(receipt.total, specifier: "%.2f")")
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
    ReceiptsRowView(receipt: .mock)
}
