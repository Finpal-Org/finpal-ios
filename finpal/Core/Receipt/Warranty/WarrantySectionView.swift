//
//  WarrantySectionView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/20/25.
//

import SwiftUI
import PhotosUI

struct WarrantySectionView: View {
    @State private var showWarrantyDetails: Bool = false
    @State private var isDeleteImagesEnabled: Bool = false
    
    @StateObject private var viewModel = PhotoSelectorViewModel()
    
    private let maxPhotosToSelect = 10
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Warranty")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding(.leading)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Enable Warranty Protection")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.gray80)
                    
                    Text("Save your warranty details and track the expiration date for easy access.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.gray60)
                }
                .frame(width: 250)
                
                Toggle("", isOn: $showWarrantyDetails)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 94)
            .padding(.horizontal, 12)
            .background(Color.white, in: .rect(cornerRadius: 20))
            .padding(.horizontal, 16)
            .mediumShadow()
            
            if showWarrantyDetails {
                VStack(spacing: 32) {
                    imagesSection
                    
                    WarrantyDurationInput()
                }
                .transition(.fade(duration: 0.75))
            }
        }
        .animation(.smooth, value: showWarrantyDetails)
        .onChange(of: viewModel.selectedPhotos) { _, _ in
            viewModel.convertDataToImage()
        }
    }
    
    private var imagesSection: some View {
        VStack(alignment: .leading) {
            Text("Item Image")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding([.horizontal, .top], 16)
            
            if viewModel.images.isEmpty {
                noImageView
            } else {
                imageViewer
            }
        }
    }
    
    private var noImageView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("There are no images set.")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                
                Text("Adding images is optional. You can continue without them.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.gray60)
            }
            
            Divider()
            
            PhotosPicker(
                selection: $viewModel.selectedPhotos,
                maxSelectionCount: maxPhotosToSelect,
                selectionBehavior: .ordered,
                matching: .images,
                label: {
                    Text("Browse Files")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brand60)
                        .frame(width: 110, height: 40)
                        .background {
                            Capsule()
                                .strokeBorder(Color.brand60, lineWidth: 1)
                        }
                        .clipShape(.capsule)
                }
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 172)
        .background(Color.white, in: .rect(cornerRadius: 24))
        .padding(.horizontal, 16)
        .mediumShadow()
    }
    
    private var addImagesButton: some View {
        PhotosPicker(
            selection: $viewModel.selectedPhotos,
            maxSelectionCount: maxPhotosToSelect,
            selectionBehavior: .ordered,
            matching: .images,
            label: {
                HStack {
                    Image(systemName: "plus.circle")
                        .imageScale(.medium)
                    
                    Text("Add Images")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(Color.brand60)
            }
        )
    }
    
    private var deleteImagesButton: some View {
        Button {
            isDeleteImagesEnabled.toggle()
        } label: {
            HStack {
                Image(systemName: "minus.circle")
                    .imageScale(.medium)
                
                Text("Delete Image")
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .foregroundStyle(Color.brand60)
    }
    
    private var imageViewer: some View {
        VStack {
            ImageViewer {
                ForEach(viewModel.images.indices, id: \.self) { index in
                    Image(uiImage: viewModel.images[index])
                        .resizable()
                        .containerValue(\.activeViewID, index)
                        .overlay {
                            if isDeleteImagesEnabled {
                                Image(systemName: "trash.square")
                                    .font(.system(size: 48, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .onTapGesture {
                                        onDeleteImagePressed(index: index)
                                    }
                            }
                        }
                }
            } overlay: {
                OverlayView()
            }
            .padding(.horizontal)
            
            Divider()
                .padding()
            
            HStack {
                addImagesButton
                
                Spacer()
                
                deleteImagesButton
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func onDeleteImagePressed(index: Int) {
        withAnimation(.bouncy) {
            viewModel.removeImage(at: index)
        }
    }
}

private struct OverlayView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.ultraThinMaterial)
                    .padding(10)
                    .contentShape(.rect)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
        }
        .padding(16)
    }
}

#Preview {
    WarrantySectionView()
}
