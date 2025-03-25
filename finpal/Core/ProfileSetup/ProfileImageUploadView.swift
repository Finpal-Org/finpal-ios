//
//  ProfileImageUploadView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/24/25.
//

import SwiftUI

struct ProfileImageUploadView: View {
    var body: some View {
        VStack {
            toolbarView
            
            Spacer()
            
            titleView
            
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
            
            ProgressView(value: 0.8)
                .progressViewStyle(FinpalProgressViewStyle())
            
            Text("Skip")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.brand60)
                .anyButton {
                    
                }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private var titleView: some View {
        VStack(spacing: 64) {
            Text("Let's Set Up Your Profile Image or Avatar")
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            avatarSelectionView
            
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    uploadButton
                    premadeButton
                }
                
                skipButton
            }
        }
    }
    
    private var avatarSelectionView: some View {
        ZStack {
            Circle()
                .fill(Color.gray10)
                .frame(width: 128, height: 128)
            
            Image(systemName: "person")
                .font(.system(size: 64, weight: .semibold))
                .foregroundStyle(Color.brand60)
        }
    }
    
    private var uploadButton: some View {
        HStack(spacing: 10) {
            Text("Upload Photo")
            
            Image(systemName: "square.and.arrow.up")
        }
        .callToActionButton()
        .anyButton(.press) {
            
        }
        .padding(.horizontal)
    }
    
    private var premadeButton: some View {
        Text("Or Choose Premade Ones")
            .secondaryButton(backgroundColor: Color.white)
            .anyButton(.press) {
                
            }
            .padding(.horizontal)
    }
    
    private var skipButton: some View {
        Text("Skip this step")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(Color.brand60)
            .anyButton {
                
            }
    }
    
}

#Preview {
    ProfileImageUploadView()
}
