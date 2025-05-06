//
//  GoalOnboardingWelcomeView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI

struct GoalOnboardingWelcomeView: View {
    @Binding var page: Int
    
    let name: String?
    
    var unwrappedName: String {
        if let name {
            return "\(name)! "
        }
        return ""
    }
    
    var body: some View {
        VStack {
            Text("\(unwrappedName)I'm finpal, your AI finance companion. I'll help set up your goal. Are you ready? Let's go! 👍")
                .multilineTextAlignment(.leading)
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color.gray80)
                .tracking(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12) {
                HStack {
                    Text("Yes, Start")
                    
                    Image(systemName: "arrow.right")
                }
                .callToActionButton()
                .frame(width: 142)
                .anyButton(.press) {
                    page += 1
                }
                
                HStack {
                    Image(systemName: "chevron.left")
                    
                    Text("No, Go Back")
                }
                .secondaryButton()
                .frame(width: 162)
                .anyButton(.press) {
                    page -= 1
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    GoalOnboardingWelcomeView(page: .constant(0), name: "John")
}
