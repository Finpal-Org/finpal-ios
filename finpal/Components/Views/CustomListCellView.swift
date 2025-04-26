//
//  CustomListCellView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/26/25.
//

import SwiftUI

struct CustomListCellView: View {
    var imageName: String? = Constants.randomImageURL
    var title: String? = "Alpha"
    var subtitle: CategoryModel? = .communication
    var dateText: String? = Date.now.description
    var amount: Float? = 54.32
    
    var body: some View {
        HStack(spacing: 16) {
            
            ZStack {
                if let imageName {
                    ImageLoaderView(urlString: imageName)
                } else {
                    Rectangle()
                        .fill(.secondary.opacity(0.5))
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(height: 48)
            .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 5) {
                if let title {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                }
                
                if let subtitle {
                    Label(subtitle.rawValue, systemImage: subtitle.iconName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.gray80)
                }
                
                if let dateText {
                    Text(dateText)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color.gray60)
                }
            }
            
            Spacer()
            
            // Total
            if let amount {
                Text(amount, format: .currency(code: "SAR"))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.gray80)
            }
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
    CustomListCellView()
}
