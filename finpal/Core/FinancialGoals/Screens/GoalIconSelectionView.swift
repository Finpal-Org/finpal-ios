//
//  GoalIconSelectionView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI

struct GoalIconSelectionView: View {
    @Binding var page: Int
    @Binding var selectedIcon: String
    
    private let goalIcons = [
        "popcorn", "gift", "leaf", "printer",
        "cart", "graduationcap", "house", "car",
        "tree", "airplane", "music.note", "hanger",
        "figure.walk", "dumbbell", "archivebox", "pin"
    ]
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack {
            Text("Choose an icon to represent your goal")
                .multilineTextAlignment(.leading)
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color.gray80)
                .tracking(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<16) { index in
                    ZStack {
                        ZStack {
                            if selectedIcon == goalIcons[index] {
                                Circle()
                                    .stroke(Color.brand60, lineWidth: 2)
                                    .fill(Color.brand5)
                            } else {
                                Circle()
                                    .fill(Color.white)
                            }
                        }
                        .frame(width: 76, height: 76)
                        .mediumShadow()
                            
                        Image(systemName: goalIcons[index])
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(Color.gray80)
                    }
                    .anyButton(.press) {
                        selectedIcon = goalIcons[index]
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12) {
                HStack {
                    Text("Continue")
                    
                    Image(systemName: "arrow.right")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(selectedIcon == "" ? Color.brand30 : Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(selectedIcon == "" ? Color.brand10 : Color.brand60)
                .clipShape(.capsule)
                .frame(width: 142)
                .anyButton(.press) {
                    page += 1
                }
                .disabled(selectedIcon == "")
                
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
    @Previewable @State var iconName = ""
    GoalIconSelectionView(page: .constant(1), selectedIcon: $iconName)
}
