//
//  GoalCreationLoadingView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI

struct GoalCreationLoadingView: View {
    var body: some View {
        VStack {
            Text("Please wait...")
                .multilineTextAlignment(.leading)
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color.gray80)
                .tracking(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    GoalCreationLoadingView()
}
