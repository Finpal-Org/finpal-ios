//
//  AvatarPickerView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/25/25.
//

import SwiftUI

struct AvatarPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var avatarImage: UIImage?
    
    @State private var selectedIndex: Int = 1
    
    var body: some View {
        VStack(spacing: 48) {
            toolbarView
            
            Spacer()
            
            Text("Choose Avatars")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            carouselView
            selectAvatarButton
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
    }
    
    private var toolbarView: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray80)
                .anyButton {
                    dismiss()
                }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private var carouselView: some View {
        VStack(spacing: 24) {
            CarouselView(selectedIndex: $selectedIndex) { index in
                Image("\(selectedIndex == index ? "Colored" : "Dark")Avatar_\(index)")
                    .resizable()
            }
            
            Text("\(selectedIndex) of 12")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.gray60)
        }
    }
    
    private var selectAvatarButton: some View {
        HStack {
            Text("Select Avatar")
            
            Image(systemName: "checkmark")
        }
        .callToActionButton()
        .anyButton(.press) {
            onSelectAvatarPressed()
        }
        .padding(.horizontal)
    }
    
    private func onSelectAvatarPressed() {
        avatarImage = UIImage(named: "ColoredAvatar_\(selectedIndex)")
        dismiss()
    }
    
}

#Preview {
    AvatarPickerView(avatarImage: .constant(UIImage(resource: .coloredAvatar1)))
}
