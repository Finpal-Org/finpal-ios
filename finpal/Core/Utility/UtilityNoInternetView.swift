//
//  UtilityNoInternetView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/5/25.
//

import SwiftUI

struct UtilityNoInternetView: View {
    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Image(.finpalNoInternet)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)
            }
            
            VStack(spacing: 24) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.destructive50)
                    
                    Text("Error Code: 100")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.destructive60)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.destructive5, in: .capsule)
                
                VStack(spacing: 12) {
                    Text("No Internet")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(Color.gray80)
                    
                    Text("You’re not connected to the internet. Please check your Wi-Fi or mobile data and try again.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.gray60)
                }
                
                HStack {
                    Image(systemName: "repeat")
                    
                    Text("Try Again")
                }
                .callToActionButton()
                .anyButton(.press) {
                    
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    UtilityNoInternetView()
}
