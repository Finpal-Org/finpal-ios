//
//  ProfileImageUploadView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/24/25.
//

import SwiftUI
import PhotosUI

struct ProfileImageUploadView: View {
    var size: CGSize
    
    @Binding var currentIndex: Int
    
    @Bindable var viewModel: ProfileSetupViewModel
    
    @State private var avatarItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            Spacer()
            
            titleView
            
            Spacer()
        }
        .safeAreaInset(edge: .bottom, alignment: .center, spacing: 16) {
            ZStack {
                if viewModel.profileImage != nil {
                    continueButton
                        .addButtonAnimation(size: size, index: 3, currentIndex: currentIndex)
                }
            }
            .padding()
        }
        .animation(.bouncy, value: viewModel.profileImage)
    }
    
    private var titleView: some View {
        VStack(spacing: 64) {
            Text("Let's Set Up Your Profile Image or Avatar")
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.gray80)
                .addTitleAnimation(size: size, index: 3, currentIndex: currentIndex)
            
            avatarSelectionView
                .addSubtitleAnimation(size: size, index: 3, currentIndex: currentIndex)
            
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    uploadButton
                    premadeButton
                }
                
                skipButton
            }
            .addButtonAnimation(size: size, index: 3, currentIndex: currentIndex)
        }
    }
    
    private var avatarSelectionView: some View {
        ZStack {
            if let avatarImage = viewModel.profileImage {
                Image(uiImage: avatarImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 128, height: 128)
                    .clipShape(.circle)
            } else {
                Circle()
                    .fill(Color.gray10)
                    .frame(width: 128, height: 128)
                
                Image(systemName: "person")
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundStyle(Color.brand60)
            }
        }
    }
    
    private var uploadButton: some View {
        PhotosPicker(selection: $avatarItem, matching: .images) {
            HStack(spacing: 10) {
                Text("Upload Photo")
                
                Image(systemName: "square.and.arrow.up")
            }
        }
        .callToActionButton()
        .padding(.horizontal)
        .onChange(of: avatarItem, loadImage)
    }
    
    private var premadeButton: some View {
        NavigationLink {
            AvatarPickerView(avatarImage: $viewModel.profileImage)
                .toolbarVisibility(.hidden, for: .navigationBar)
        } label: {
            Text("Or Choose Premade Ones")
        }
        .secondaryButton()
        .padding(.horizontal)
    }
    
    private var skipButton: some View {
        Text("Skip this step")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(Color.brand60)
            .anyButton {
                Task {
                    await onSkipButtonPressed()
                }
            }
    }
    
    private var continueButton: some View {
        HStack {
            Text("Continue")
            
            Image(systemName: "arrow.right")
        }
        .callToActionButton()
        .anyButton(.press) {
            currentIndex += 1
        }
    }
    
    private func loadImage() {
        Task {
            guard let imageData = try await avatarItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            viewModel.profileImage = inputImage
        }
    }
    
    private func onSkipButtonPressed() async {
        if viewModel.profileImage == nil {
            currentIndex += 1
        } else {
            viewModel.profileImage = nil
            try? await Task.sleep(for: .seconds(0.5))
            currentIndex += 1
        }
    }
}

#Preview {
    @Previewable @State var currentIndex: Int = 3
    
    GeometryReader { geometry in
        let size = geometry.size
        
        ProfileImageUploadView(size: size, currentIndex: $currentIndex, viewModel: .mock)
    }
}
