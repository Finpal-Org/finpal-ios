//
//  TargetGoalsView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI

struct TargetGoalsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Target Goal")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("You have no goals")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.gray80)
                        
                        Text("You haven’t set up any goals. Let’s set it up today!")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.gray60)
                    }
                    
                    Text("Set Up Now")
                        .secondaryButton()
                }
                .padding(16)
                
                Spacer()
                
                Image(.finpalNoGoals)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 140)
            }
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 24))
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 90)
        .padding(.horizontal, 16)
        .offset(x: 0, y: -32)
        .mediumShadow()
    }
}

#Preview {
    ZStack {
        Color.gray5.ignoresSafeArea()
        
        TargetGoalsView()
    }
}
