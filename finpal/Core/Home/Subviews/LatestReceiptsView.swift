//
//  LatestReceiptsView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/10/25.
//

import SwiftUI

struct LatestReceiptsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Latest Receipts")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(16)
            
            VStack(spacing: 20) {
                Image(.homeLatestReceipts)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 216)
                
                VStack(spacing: 8) {
                    Text("You have no receipts yet")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.gray80)
                    
                    Text("Your receipts will be listed here, go ahead and add your first one.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.gray60)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 16)
                
                HStack {
                    Image(systemName: "plus")
                    
                    Text("Add Receipt")
                }
                .secondaryButton()
                .anyButton(.press) {
                    
                }
            }
            .frame(height: 405)
            .padding(.horizontal, 16)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 24))
            .padding(.horizontal, 16)
            .mediumShadow()
            
        }
        .frame(maxWidth: .infinity)
        .offset(x: 0, y: -64)
    }
}

#Preview {
    LatestReceiptsView()
}
