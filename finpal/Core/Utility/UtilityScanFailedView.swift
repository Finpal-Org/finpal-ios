//
//  UtilityScanFailedView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import SwiftUI

struct UtilityScanFailedView: View {
    var body: some View {
        VStack(spacing: 32) {
            Image(.scanFailed)
            
            VStack(spacing: 24) {
                
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    
                    Text("Error Code: 202")
                }
                .frame(width: 148, height: 32)
                .padding(4)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.destructive60)
                .background(Color.destructive5)
                .clipShape(Capsule())
                
                VStack(alignment: .center, spacing: 12) {
                    Text("Scan Failed")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(Color.gray80)
                    
                    Text("Unfortunately, we couldn't process your receipt image. Please ensure the receipt is clear, well-lit, and try scanning again.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.gray60)
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                }
                .padding()
                
                HStack {
                    Image(systemName: "repeat")
                    
                    Text("Try Again")
                }
                .callToActionButton()
                .anyButton(.press, action: {
                    
                })
                .padding()
            }
        }
    }
}

#Preview {
    UtilityScanFailedView()
}
